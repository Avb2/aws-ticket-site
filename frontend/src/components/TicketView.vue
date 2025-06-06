<template>
  <div class="layout">
    <div class="tickets">
      <h1 class="header">Your Tickets</h1>
      <div id="ticketDisplay" class="ticket-box">
        <!-- Tickets go here -->
      </div>
    </div>

    <div class="sidebar">
      <div class="create-box">
        <h1 class="header">Create a Ticket</h1>
        <button id="createTicketBtn" class="create-btn">+ New Ticket</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
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
  justify-content: center; /* Add this */
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
</style>
