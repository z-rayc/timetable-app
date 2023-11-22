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



  const { chatroomId } = await req.json();

  // get chatroom
  const { data: chatroomData, error: chatroomDataError } = await supabaseClient.from('ChatRoom').select().eq('id', chatroomId).single();
  if (chatroomDataError) {
    return new Response(JSON.stringify({ error: `Error getting chatroom: ${chatroomDataError.code}` }), {
      headers: { ...corsHeaders, 'content-type': 'application/json' },
      status: 500,
    })
  }

  if (chatroomData.owner !== user.id) {
    return new Response(JSON.stringify({ error: `Forbidden`}), {
      headers: { ...corsHeaders, 'content-type': 'application/json' },
      status: 403,
    })
  }



  // get all chatroom members
  const { data: chatroomMembers, error: error } = await adminAuthCLient.from('ChatRoomMember').select('user_id').eq('chatroom_id', chatroomId);
  if (error) {
    return new Response(JSON.stringify({ error: `Error getting chatroom members: ${error.message}` }), {
      headers: { ...corsHeaders, 'content-type': 'application/json' },
      status: 500,
    })
  }

  // get all chatroom member emails
  let memberids = chatroomMembers.map((chatroomMember: any) => chatroomMember.user_id);

  // remove current user from memberids
  memberids = memberids.filter((memberid: string) => memberid !== user.id);

  const { data: memberEmails, error: memberEmailsError } = await adminAuthCLient.from('UserProfile').select('email').in('id', memberids);

  if (memberEmailsError) {
    return new Response(JSON.stringify({ error: `Error getting member emails: ${memberEmailsError.message}` }), {
      headers: { ...corsHeaders, 'content-type': 'application/json' },
      status: 500,
    })
  }

  const memberEmailsList = memberEmails.map((memberEmail: any) => memberEmail.email);


  return new Response(JSON.stringify({ memberEmailsList }), {
    headers: { ...corsHeaders, 'content-type': 'application/json' },
    status: 200,
  })

}
)