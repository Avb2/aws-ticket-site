import LoginForm  from "./components/LoginForm.vue"
import SignUpForm from "./components/SignUpForm.vue"
import TicketView from "./components/TicketView.vue"
import TicketViewAdmin from "./components/TicketViewAdmin.vue"
import { createRouter } from "vue-router"
import { createWebHistory } from "vue-router"
const routes = [
    { path: '/', component: LoginForm },
    { path: "/sign-up", component: SignUpForm },
    { path: '/home', component: TicketView },
    { path: '/admin-home', component: TicketViewAdmin },
]


const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router