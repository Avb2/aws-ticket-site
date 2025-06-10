<script setup>
import { ref } from 'vue';

import { signOut } from '@aws-amplify/auth';
import { onMounted } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();
const bearer = localStorage.getItem('bearer');
const userId = localStorage.getItem('user');
const tickets = ref([]);
const isSelected = ref(false);
let selectedId = ref()
let selectedDesc = ref()
let selectedTitle = ref()
let selectedUser = ref()


async function logout() {
  try {
    await signOut();
    router.push('/');
  } catch (err) {
    console.error('Logout error:', err);
  }
}


onMounted(async () => {
  getTickets();
});


async function getTickets() {
  const response = await fetch("https://c2vhw7f8hh.execute-api.us-east-2.amazonaws.com/get_tickets_admin", {
    method: 'GET',
    headers: {
      'Authorization': `Bearer ${bearer}`,
      'Content-Type': 'application/json'
    }
  });

  tickets.value = await response.json();
  console.log("Tickets:", tickets.value);
}


function resolveTickets() {
  fetch("https://c2vhw7f8hh.execute-api.us-east-2.amazonaws.com/resolve_ticket", {
    method: 'PUT',
    headers: {
      'Authorization': `Bearer ${bearer}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      UserId: selectedUser.value,
      Title: selectedId.value
    }),
  })
}


function toggleTicket(userId, id, title, description) {
  if (id == selectedId.value && isSelected.value == true) {
    isSelected.value = false
  } else {
    selectedUser.value = userId
    selectedId.value = id
    selectedTitle.value = title
    selectedDesc.value = description
    isSelected.value = true

  }


}
</script>


<template>
  <button class="logout-btn" @click="logout">Logout</button>
  <div class="layout">
    <div class="tickets">
      <h1 class="header">Your Tickets</h1>
      <div id="ticketDisplay" class="ticket-box">

        <div @click="toggleTicket(ticket.UserId, ticket.TicketId, ticket.Title, ticket.Description)"
          v-for="ticket in tickets" :key="ticket.TicketId" class="ticket-card">
          <b><span id="ticket-title">{{ ticket.Title }}</span> | <span id="ticket-id">{{ ticket.TicketId }}</span></b>
          <p>
            {{ ticket.Description }}
          </p>
        </div>

      </div>
    </div>

    <div class="sidebar" v-show="isSelected">
      <div class="display-ticket">
        <h2>
          Ticket Id
        </h2>
        <p>{{ selectedId }}</p>

        <h2>Title</h2>
        <p>{{ selectedTitle }}</p>

        <h2>Description</h2>
        <p>{{ selectedDesc }}</p>





        <button @click="resolveTickets" id="resolveTicketBtn" class="resolve-btn">Resolve</button>
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

.ticketCard {
  color: #111827;
  text-align: center;
  padding: 1.25rem;
  margin: 1rem 0;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  font-size: 1.1rem;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
  transition: transform 0.2s ease;
}

.ticketCard:hover {
  transform: translateY(-2px);
}

.ticketCard p {
  margin: 0.5rem 0;
  font-weight: 500;
  letter-spacing: 0.5px;
  line-height: 1.4;
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
  height: 500px;
  background: #f3f4f6;
  padding: 2rem 1rem;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  /* Add this */
}

.display-ticket {
  color: #111827;
  width: 100%;
  background: #ffffff;
  padding: 1.5rem;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.header {
  font-weight: bold;
  font-size: 1.25rem;
  margin-bottom: 1.5rem;
  color: #111827;
  text-align: center;
}

.resolve-btn {
  padding: 0.75rem 1rem;
  font-size: 1rem;
  background-color: #3b82f6;
  color: #fff;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.2s;
}

.resolve-btn:hover {
  background-color: #2563eb;
}
</style>
