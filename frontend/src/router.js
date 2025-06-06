import LoginForm  from "./components/LoginForm.vue"
import TicketView from "./components/TicketView.vue"
import TicketViewAdmin from "./components/TicketViewAdmin.vue"
import { createRouter } from "vue-router"
import { createWebHistory } from "vue-router"
const routes = [
    { path: '/', component: LoginForm },
    { path: '/home', component: TicketView },
    { path: '/home-admin', component: TicketViewAdmin },
]


const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router