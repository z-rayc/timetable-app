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
 
     // request will contain a body with the following:
    //  {
    //     'chatroomname': 'test',
    //     'memberemails': ['email1', 'email2', 'email3'],
    //  }

    const { chatroomName, memberEmails } = await req.json();
    
     // get userid from emails, use auth schema
    // const { data: users, error } = await supabaseClient.from('auth.users').select('id').in('email', memberEmails);
    // use await supabaseClient.auth.admin.listUsers

    const { data: users, error } = await adminAuthCLient.auth.admin.listUsers();
    
    // const { data: users, error } = await adminAuthCLient.from('users').select('id').in('email', memberEmails);
     
    if (error) {
      return new Response(JSON.stringify({ error: `Error getting users: ${error.message}` }), {
        headers: {...corsHeaders, 'content-type': 'application/json'},
        status: 500,
      })
    }

    console.log(users);
    console.dir(users);
    const mambers = users.filter((user: any) => memberEmails.includes(user.email));

    const memberids = mambers.map((user: any) => user.id);
    memberids.push(user.id)

    // adminAuthCLient.from('users').schema('auth').select()... where email in memberEmails

    // const memberids = users.map((user: any) => user.id);
    // memberids.push(user.id)

    


    // create chatroom
    const { data: chatroom, error: chatroomError } = await supabaseClient.from('chatrooms').insert([{ name: chatroomName }]).select().single();
    if (chatroomError) {
      return new Response(JSON.stringify({ error: 'Error creating chatroom' }), {
        headers: {...corsHeaders, 'content-type': 'application/json'},
        status: 500,
      })
    }
    const chatroomid = chatroom.id;

    // create chatroom members
    const { data: chatroomMembers, error: chatroomMembersError } = await supabaseClient.from('chatroommembers').insert(memberids.map((memberid: string) => ({ chatroomid, memberid }))).select();
    if (chatroomMembersError) {
      return new Response(JSON.stringify({ error: 'Error creating chatroom members' }), {
        headers: {...corsHeaders, 'content-type': 'application/json'},
        status: 500,
      })
    }

    return new Response(JSON.stringify({ chatroom, chatroomMembers }), {
      headers: {...corsHeaders, 'content-type': 'application/json'},
      status: 200,
    })
    }


 )