<script setup>
import { Amplify } from 'aws-amplify';
    const bearer = ref(null)
    const username = ref('')
    const password = ref('')

    Amplify.configure({
        Auth: {
            region: "us-east-1",
            userPoolId: "",
            userPoolWebClientId: ""
        }
    });

    async function signIn(){
       try {
            const user = await Auth.signIn(username.value, password.value)
            const session = await Auth.currentSession()
            bearer.value = session.getIdToken().getJwtToken()
            console.log('Token:', bearer.value)
        } catch (err) {
            console.error(err)
        }
    }   



</script>


<template>


  <div class="login-container">
    <h2>Login</h2>
    <form>
      <input v-model="username" type="text" placeholder="Username" required />
      <input v-model="password" type="password" placeholder="Password" required />
      <button type="submit">Sign In</button>
    </form>
  </div>


</template>



<style>
    body {
      background-color: #f0f4f8;
      font-family: Arial, sans-serif;
      display: flex;
      height: 100vh;
      align-items: center;
      justify-content: center;
    }

    .login-container {
      background-color: #fff;
      padding: 2rem;
      border-radius: 12px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      width: 320px;
    }

    .login-container h2 {
      text-align: center;
      margin-bottom: 1.5rem;
      color: #333;
    }

    .login-container input[type="text"],
    .login-container input[type="password"] {
      width: 100%;
      padding: 0.75rem;
      margin-bottom: 1rem;
      border: 1px solid #ccc;
      border-radius: 8px;
      font-size: 1rem;
    }

    .login-container button {
      width: 100%;
      padding: 0.75rem;
      background-color: #4a90e2;
      color: white;
      border: none;
      border-radius: 8px;
      font-size: 1rem;
      cursor: pointer;
    }

    .login-container button:hover {
      background-color: #357ac9;
    }
</style>