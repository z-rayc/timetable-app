import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.7.1'

const SUPABASE_URL = Deno.env.get('SUPABASE_URL');
const SUPABASE_ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY');
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');

export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}



Deno.serve(async (req: Request) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      status: 200,
      headers: corsHeaders,
    })
  }



  const supabaseClient = createClient(
    SUPABASE_URL!,
    SUPABASE_ANON_KEY!,

    {
      global: {
        headers: { Authorization: req.headers.get('Authorization')! },
      },
    }
  )

  const {
    data: { user },
  } = await supabaseClient.auth.getUser()

  if (!user) {
    return new Response(JSON.stringify({ error: 'Unauthorized' }), {
      headers: { ...corsHeaders, 'content-type': 'application/json' },
      status: 401,
    })
  }



  const adminAuthCLient = createClient(SUPABASE_URL!, SERVICE_ROLE_KEY!, {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  })



  const { chatroomId, chatroomName, memberEmails } = await req.json();


  const { data: existingChatRoomm, error: chatroomDataError } = await supabaseClient.from('ChatRoom').select().eq('id', chatroomId).single();
  if (chatroomDataError) {
    return new Response(JSON.stringify({ error: `Error getting chatroom: ${chatroomDataError.code}` }), {
      headers: { ...corsHeaders, 'content-type': 'application/json' },
      status: 500,
    })
  }
  if (existingChatRoomm.owner !== user.id) {
    return new Response(JSON.stringify({ error: `Forbidden` }), {
      headers: { ...corsHeaders, 'content-type': 'application/json' },
      status: 403,
    })
  }

  // get current members
  const { data: currentMembers, error: currentMembersError } = await adminAuthCLient.from('ChatRoomMember').select('user_id').eq('chatroom_id', chatroomId);
  if (currentMembersError) {
    return new Response(JSON.stringify({ error: `Error getting current members: ${currentMembersError.code}` }), {
      headers: { ...corsHeaders, 'content-type': 'application/json' },
      status: 500,
    })
  }

  const currentMemberids = currentMembers.map((member: any) => member.user_id);




  const { data: newUsers, error } = await adminAuthCLient.from('UserProfile').select('id').in('email', memberEmails);
  if (error) {
    return new Response(JSON.stringify({ error: `Error getting users: ${error.message}` }), {
      headers: { ...corsHeaders, 'content-type': 'application/json' },
      status: 500,
    })
  }
  const newMemberids = newUsers.map((user: any) => user.id);
  newMemberids.push(user.id) // add the current user to the chatroom

  if (newMemberids.length < 2) {

    return new Response(JSON.stringify({ error: 'Not enough valid members' }), {
      headers: { ...corsHeaders, 'content-type': 'application/json' },
      status: 400,
    })
  }

  const userIdsToAdd = newMemberids.filter((id: string) => !currentMemberids.includes(id));
  const userIdsToRemove = currentMemberids.filter((id: string) => !newMemberids.includes(id));

  // add new members
  const { error: addMembersError } = await adminAuthCLient.from('ChatRoomMember').insert(
    userIdsToAdd.map((memberid: string) => ({
      chatroom_id: chatroomId,
      user_id: memberid,
    }))
  );
  if (addMembersError) {
    return new Response(JSON.stringify({ error: `Error adding members: ${addMembersError.code}` }), {
      headers: { ...corsHeaders, 'content-type': 'application/json' },
      status: 500,
    })
  }

  // remove old members
  const { error: removeMembersError } = await adminAuthCLient.from('ChatRoomMember').delete().in('user_id', userIdsToRemove);
  if (removeMembersError) {
    return new Response(JSON.stringify({ error: `Error removing members: ${removeMembersError.code}` }), {
      headers: { ...corsHeaders, 'content-type': 'application/json' },
      status: 500,
    })
  }

  // if name changed, update name
  let chatroom = existingChatRoomm;
  if (chatroomName !== existingChatRoomm.name) {
    const { data: updatedChatRoom, error: updateNameError } = await adminAuthCLient
      .from('ChatRoom')
      .update({ name: chatroomName })
      .eq('id', chatroomId)
      .select()
      .single();
    if (updateNameError) {
      return new Response(JSON.stringify({ error: `Error updating name: ${updateNameError.code}` }), {
        headers: { ...corsHeaders, 'content-type': 'application/json' },
        status: 500,
      })
    }
    chatroom = updatedChatRoom;
  }

  return new Response(JSON.stringify({ chatroom }), {
    headers: { ...corsHeaders, 'content-type': 'application/json' },
    status: 200,
  })



}


)