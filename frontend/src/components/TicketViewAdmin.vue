<script setup>
import { ref } from 'vue';

let tickets = [
    {id: 120322, severity: 3, description: "My computer is malfunctioning"},
    {id: 294924, severity: 1, description: "My toaster is on fire"},
    {id: 532342, severity: 8, description: "My house is burning"}
];

let isSelected = ref(false);

let selectedId = ref()
let selectedDesc = ref()
let selectedSev = ref()

function showTicket(id, description, severity){
   if (isSelected & selectedId == id) {
    isSelected.value = false
   } else {
        selectedId.value = id
        selectedDesc.value = description
        selectedSev.value = severity
        isSelected.value = true
   }
}
</script>


<template>
  <div class="layout">
    <div class="tickets">
      <h1 class="header">Your Tickets</h1>
      <div id="ticketDisplay" class="ticket-box" v-for="ticket in tickets">
        <div class="ticketCard" @click="showTicket(ticket.id, ticket.description, ticket.severity)">
            <h2>{{ ticket.id }} - {{ ticket.severity }}</h2>
            <h3>{{ ticket.description }}</h3>
        </div>
      </div>
    </div>

    <div class="sidebar" v-show="isSelected">
      <div class="display-ticket">
        <h2>
            Ticket Id
        </h2>
        <p>{{ selectedId }}</p>
        
        <h2>Description</h2>
        <p>{{ selectedDesc }}</p>

        <h2>Severity</h2>
        <p>{{ selectedSev }}</p>



        <button id="resolveTicketBtn" class="resolve-btn">Resolve</button>
      </div>
    </div>
  </div>
</template>



<style scoped>

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
  justify-content: center; /* Add this */
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
