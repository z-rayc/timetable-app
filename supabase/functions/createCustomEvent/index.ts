import { createClient } from "https://esm.sh/@supabase/supabase-js@2.7.1";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL");
const SUPABASE_ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY");
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

export const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, {
      status: 200,
      headers: corsHeaders,
    });
  }

  const supabaseClient = createClient(
    SUPABASE_URL!,
    SUPABASE_ANON_KEY!,

    {
      global: {
        headers: { Authorization: req.headers.get("Authorization")! },
      },
    }
  );

  const {
    data: { user },
  } = await supabaseClient.auth.getUser();

  if (!user) {
    return new Response(JSON.stringify({ error: "Unauthorized" }), {
      headers: { ...corsHeaders, "content-type": "application/json" },
      status: 401,
    });
  }

  const adminAuthClient = createClient(SUPABASE_URL!, SERVICE_ROLE_KEY!, {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  });

  const {
    name,
    description,
    start_time,
    end_time,
    creatorId,
    room,
    building,
    link,
    memberEmails,
  } = await req.json();

  // Get the IDs of the users
  const { data: users, error } = await adminAuthClient
    .from("UserProfile")
    .select("id")
    .in("email", memberEmails);

  if (error) {
    return new Response(
      JSON.stringify({ error: `Error getting users: ${error.message}` }),
      {
        headers: { ...corsHeaders, "content-type": "application/json" },
        status: 500,
      }
    );
  }

  const memberIds = users.map((user: any) => user.id);
  memberIds.push(user.id); // Add the current user to the list of members too

  // Create the custom event
  const { data: customEvent, error: customEventError } = await supabaseClient
    .from("CustomEvents")
    .insert({
      name: name,
      description: description,
      start_time: start_time,
      end_time: end_time,
      creator: creatorId,
      room: room,
      building: building,
      link: link,
    })
    .select()
    .single();

  // Print the custom event and error
  console.dir(customEvent);
  console.dir(customEventError);

  if (customEventError) {
    return new Response(
      JSON.stringify({
        error: `Error creating custom event: ${customEventError.code}`,
      }),
      {
        headers: { ...corsHeaders, "content-type": "application/json" },
        status: 500,
      }
    );
  }

  const eventId = customEvent.id;

  // Create the custom event members
  const { error: memberError } = await supabaseClient
    .from("CustomEventsMembers")
    .insert(
      memberIds.map((memberid: string) => ({
        event_id: eventId,
        user_id: memberid,
      }))
    );
  if (memberError) {
    return new Response(
      JSON.stringify({
        error: `Error creating custom event members: ${JSON.stringify(
          memberError
        )}`,
      }),
      {
        headers: { ...corsHeaders, "content-type": "application/json" },
        status: 500,
      }
    );
  }

  return new Response(JSON.stringify({ customEvent }), {
    headers: { ...corsHeaders, "content-type": "application/json" },
    status: 201,
  });
});
