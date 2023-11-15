// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.7.1'


const SUPABASE_URL =  Deno.env.get('SUPABASE_URL');
const SUPABASE_ANON_KEY =  Deno.env.get('SUPABASE_ANON_KEY');
const API_KEY =  Deno.env.get('API_KEY');
const TP_URL =  Deno.env.get('TP_URL');

export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

console.log("Hello from Functions!")


export interface Event {
  semesterid: string
  courseid: string
  courseversion: string
  actid: string
  id: string
  weeknr: number
  dtstart: string
  dtend: string
  lopenr: number
  "teaching-method": string
  "teaching-method-name": string
  "teaching-title": string
  summary: string
  status_plenary: boolean
  staffs: Staff[]
  studentgroups: string[]
  room: Room[]
  terminnr: number
  aid: string
  active: boolean
  compulsory: boolean
  discipline: any[]
  disciplineobj: any[]
  resources: any[]
  alerts: any[]
  coursetype: string
  staff: string[]
  staffnames: string[]
  editurl: string
  curr: string
  status: string
  weekday: number
  eventid: string
  multiday: boolean
}
export interface Staff {
  id: string
  lastname: string
  firstname: string
  shortname: string
  url: string
}

export interface Room {
  id: string
  roomid: string
  roomurl: string
  campusid: string
  roomname: string
  videolink: boolean
  buildingid: string
  buildingurl: string
  campusowner: any
  roomacronym: string
  buildingname: string
  showforstudent: boolean
  buildingacronym: string
  equipment_function: any
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

    const { id } = await req.json();
    
    // Get the course data from the tp api
    const tpResponse = await fetch(`${TP_URL}ws/1.4/course.php?id=${id}&sem=23h`, {
      headers: {
        'X-Gravitee-Api-Key': `${API_KEY}`
      }
    })
    

    // Return the data from the tp api
    const tpData = await tpResponse.json()

    const { courseid, coursename, title} = tpData

    // Insert the course data into the database


      // Insert the events data into the database
      const events: Event[] = tpData.events

      // create an array of events to insert in the form of {courseId, semesterid, start, end}
      const eventsToInsert = events.map(event => {
        return {
          courseId: courseid,
          semesterid: event.semesterid,
          start: event.dtstart,
          end: event.dtend,
          id: event.eventid,
          roomid: event.room[0].id,
          staffid: event.staffs[0].id,
          "teaching_summary": event.summary,
        }
      })


      // create an array of rooms to insert in the form of {id, roomid, roomurl, campusid, roomname,roomacronym, buildingname}
      let roomsToInsert = events.map(event => {
        return {
          id: event.room[0].id,
          roomid: event.room[0].roomid,
          roomurl: event.room[0].roomurl,
          campusid: event.room[0].campusid,
          roomname: event.room[0].roomname,
          roomacronym: event.room[0].roomacronym,
          buildingname: event.room[0].buildingname
        }
      })

      // remove duplicates from the rooms array
      roomsToInsert = roomsToInsert.filter((room, index, self) =>
        index === self.findIndex((t) => (
          t.id === room.id
        ))
      )


      // create an array of staffs to insert in the form of {id, lastname, firstname, shortname, url}
      let staffsToInsert = events.map(event => {
        return {
          id: event.staffs[0].id,
          lastname: event.staffs[0].lastname,
          firstname: event.staffs[0].firstname,
          shortname: event.staffs[0].shortname,
          url: event.staffs[0].url
        }
      })

      // remove duplicates from the staffs array
      staffsToInsert = staffsToInsert.filter((staff, index, self) =>
        index === self.findIndex((t) => (
          t.id === staff.id
        ))
      )


      // Insert the rooms data into the database
      const { data: roomResponse, error: roomError } = await supabaseClient
      .from('Room')
      .upsert(roomsToInsert, {
        onConflict: 'id',
        ignoreDuplicates: true,
      })

      // Insert the staffs data into the database
      const { data: staffResponse, error: staffError } = await supabaseClient
      .from('Staff')
      .upsert(staffsToInsert, {
        onConflict: 'id',
        ignoreDuplicates: true,
      })




  const { data: eventResponse, error: eventError } = await supabaseClient
  .from('Events')
  .upsert(eventsToInsert, {
    onConflict: 'id',
    ignoreDuplicates: true,
  })
  
  


    //handle all errors and return the error message if there is one else return success
    if (  roomError || staffError || eventError) {
      const data = { error: roomError?.message || staffError?.message || eventError?.message }
      return new Response(JSON.stringify(data), {
        headers: {...corsHeaders, 'content-type': 'application/json'},
        status: 400,
      })
    }

    const responseData = { message: 'Success' }
    return new Response(JSON.stringify(responseData), {
      headers: {...corsHeaders, 'content-type': 'application/json'},
      status: 200,
    })

 } 


// To invoke:
// curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/' \
//   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
//   --header 'Content-Type: application/json' \
//   --data '{"name":"Functions"}'
)