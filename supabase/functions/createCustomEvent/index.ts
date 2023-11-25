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
    title,
    description,
    start_time,
    end_time,
    creator,
    room,
    building,
    link,
    memberEmails,
  } = await req.json();

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
      title,
      description,
      start_time,
      end_time,
      creator,
      room,
      building,
      link,
    });

  const eventId = customEvent.id;

  // Create the custom event members
});
