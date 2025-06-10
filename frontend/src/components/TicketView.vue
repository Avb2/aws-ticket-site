<script setup>
import { signOut } from '@aws-amplify/auth';
import { onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { ref } from 'vue';

const router = useRouter();
const bearer = localStorage.getItem('bearer');
const userId = localStorage.getItem('user');
const tickets = ref([]);
const create = ref(false)
const ticketTitle = ref();
const ticketDescription = ref();




onMounted(async () => {
  getTickets();
});

async function getTickets() {
  const response = await fetch(`https://c2vhw7f8hh.execute-api.us-east-2.amazonaws.com/get_tickets/${userId}`, {
    method: 'GET',
    headers: {
      'Authorization': `Bearer ${bearer}`,
      'Content-Type': 'application/json'
    }
  });

  tickets.value = await response.json();
  console.log("Tickets:", tickets.value);
}


async function logout() {
  try {
    await signOut();
    router.push('/');
  } catch (err) {
    console.error('Logout error:', err);
  }
}


async function createTicket() {
  console.log(ticketTitle.value)
  console.log(ticketDescription.value)
  const currentTime = Math.floor(Date.now() / 1000)
  await fetch('https://c2vhw7f8hh.execute-api.us-east-2.amazonaws.com/create_ticket', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${bearer}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      UserId: userId,
      Status: 0,
      CreatedAt: currentTime,
      Title: ticketTitle.value,
      Description: ticketDescription.value
    }),
  });
  toggleCreate();
  getTickets();

}

function toggleCreate() {
  create.value = !create.value
}
</script>


<template>
  <div class="layout">
    <div class="tickets">
      <h1 class="header">Your Tickets</h1>
      <div id="ticketDisplay" class="ticket-box">

        <div v-if="tickets.length > 0" v-for="ticket in tickets" :key="ticket.TicketId" class="ticket-card">
          <b><span id="ticket-title">{{ ticket.Title }}</span> | <span id="ticket-id">{{ ticket.TicketId }}</span></b>
          <p>
            {{ ticket.Description }}
          </p>
        </div>

      </div>
    </div>

    <div class="sidebar">
      <button class="logout-btn" @click="logout">Logout</button>

      <div v-if="!create" class="create-box">
        <h1 class="header">New Ticket</h1>
        <button @click="toggleCreate" id="createTicketBtn" class="create-btn">New Ticket</button>
      </div>

      <div v-else="create" class="create-box">
        <h1 class="header">New Ticket</h1>
        <form @submit.prevent="createTicket">
          <input v-model="ticketTitle" placeholder="Title" />
          <input v-model="ticketDescription" placeholder="Description" />
          <button type="submit" id="createTicketBtn" class="create-btn">Create</button>
        </form>


      </div>



    </div>
  </div>
</template>


<style scoped>
#ticket-title {
  color: blue;
}

#ticket-id {
  color: #2563eb;
}


.ticket-card {
  text-align: center;
  width: 100w;
  border: solid;
  border-color: #1118272B;
}

.ticket-card:hover {
  border-color: #074BA3FF;
}

.layout {
  display: flex;
  width: 90vw;
  height: 100vh;
  overflow: hidden;
}

.tickets {
  flex: 1;
  padding: 2rem;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
}

.ticket-box {
  flex: 1;
  background: #fff;
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 1rem;
  overflow-y: auto;
}

.sidebar {
  width: 250px;
  background: #f3f4f6;
  padding: 2rem 1rem;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  /* Add this */
}

.create-box {
  width: 100%;
  background: #ffffff;
  padding: 1.5rem;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  align-items: center;
}

.header {
  font-size: 1.25rem;
  margin-bottom: 1.5rem;
  color: #111827;
  text-align: center;
}

.create-btn {
  padding: 0.75rem 1rem;
  font-size: 1rem;
  background-color: #3b82f6;
  color: #fff;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.2s;
}

.create-btn:hover {
  background-color: #2563eb;
}

.logout-btn {
  padding: 0.5rem 1rem;
  font-size: 0.95rem;
  margin-bottom: 1.5rem;
  background-color: #ef4444;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.2s;
}

.logout-btn:hover {
  background-color: #dc2626;
}
</style>
