import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.7.1'

const SUPABASE_URL =  Deno.env.get('SUPABASE_URL');
const SUPABASE_ANON_KEY =  Deno.env.get('SUPABASE_ANON_KEY');
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
           headers: {Authorization: req.headers.get('Authorization')!},
         },
       }
     )
 
     const {
       data: { user},
     } = await supabaseClient.auth.getUser()
 
     if (!user) {
       return new Response(JSON.stringify({ error: 'Unauthorized' }), {
         headers: {...corsHeaders, 'content-type': 'application/json'},
         status: 401,
       })
     }

     

     const adminAuthCLient = createClient(SUPABASE_URL!, SERVICE_ROLE_KEY!, {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    })
 


    const { chatroomName, memberEmails } = await req.json();
    

    
    const { data: users, error } = await adminAuthCLient.from('UserProfile').select('id').in('email', memberEmails);
     
    if (error) {
      return new Response(JSON.stringify({ error: `Error getting users: ${error.message}` }), {
        headers: {...corsHeaders, 'content-type': 'application/json'},
        status: 500,
      })
    }

    
   
    const memberids = users.map((user: any) => user.id);
    memberids.push(user.id) // add the current user to the chatroom

    if (memberids.length < 2) {
      return new Response(JSON.stringify({ error: 'Not enough valid members' }), {
        headers: {...corsHeaders, 'content-type': 'application/json'},
        status: 400,
      })
    }
    


    // create chatroom
    const { data: chatroom, error: chatroomError } = await supabaseClient.from('ChatRoom').insert([{ name: chatroomName }]).select().single();
    console.dir(chatroom);
    console.dir(chatroomError);
    if (chatroomError) {
      return new Response(JSON.stringify({ error: `Error creating chatroom: ${chatroomError.code}` }), {
        headers: {...corsHeaders, 'content-type': 'application/json'},
        status: 500,
      })
    }
    const chatroomid = chatroom.id;

    // create chatroom members
    const { error: chatroomMembersError } = await supabaseClient
    .from('ChatRoomMember')
    .insert(
      memberids.map((memberid: string) => ({
        chatroom_id: chatroomid,
        user_id: memberid,
      }))
    );
    if (chatroomMembersError) {
      return new Response(JSON.stringify({ error: `Error creating chatroom members: ${JSON.stringify(chatroomMembersError)}` }), {
        headers: {...corsHeaders, 'content-type': 'application/json'},
        status: 500,
      })
    }

    return new Response(JSON.stringify({ chatroom }), {
      headers: {...corsHeaders, 'content-type': 'application/json'},
      status: 201,
    })
    }


 )