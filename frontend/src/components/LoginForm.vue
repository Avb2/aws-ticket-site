<script setup>
import { signIn, fetchAuthSession } from '@aws-amplify/auth';
import { useRouter } from 'vue-router';
import { ref } from 'vue';
import { onMounted } from 'vue';

const router = useRouter();
const username = ref('');
const password = ref('');
const bearer = ref(null);
const errorMessage = ref('');

onMounted(async () => {
  try {
    // Check if session is still valid
    const session = await fetchAuthSession();
    // If the session is valid 
    if (session?.tokens?.idToken) {
      const idToken = session.tokens.idToken.toString();
      // Get username
      const payload = session.tokens.idToken.payload;
      const username = payload["cognito:username"];
      // Set bearer and username
      localStorage.clear();
      localStorage.setItem('bearer', idToken);
      localStorage.setItem('user', username);

      // Determine user group
      const claims = session.tokens?.idToken?.payload;
      const groups = claims?.['cognito:groups'] || [];
      localStorage.setItem('user', username.value);
      if (groups.includes('Admin')) {
        router.push('/admin-home');
      } else {
        router.push('/home');
      }
    }
  } catch (err) {
    console.log('No valid session', err);
  }
});

async function login() {
  try {
    const result = await signIn({
      username: username.value,
      password: password.value,
    });

    if (result?.isSignedIn) {
      const session = await fetchAuthSession();

      // ✅ SAFELY access token
      const idToken = session.tokens?.idToken?.toString();
      const claims = session.tokens?.idToken?.payload;

      if (!idToken || !claims) {
        throw new Error("Failed to retrieve session tokens.");
      }

      // ✅ Save tokens
      localStorage.setItem('bearer', idToken);
      localStorage.setItem('user', claims["cognito:username"] || username.value);

      const groups = claims['cognito:groups'] || [];

      if (groups.includes('Admin')) {
        router.push('/admin-home');
      } else {
        router.push('/home');
      }
    } else {
      errorMessage.value = 'Sign in failed or requires additional steps.';
    }
  } catch (err) {
    console.error('Sign in error:', err);
    errorMessage.value = err.message || 'An error occurred during sign in.';
  }
}

function navSignUp() {
  router.push({ path: '/sign-up' })
}
</script>

<template>
  <div class="sidebar">
    <div class="create-box">
      <h2 class="header">Login</h2>
      <form @submit.prevent="login" style="width: 100%;">
        <input v-model="username" type="text" placeholder="Username" required class="input" />
        <input v-model="password" type="password" placeholder="Password" required class="input" />
        <button type="submit" class="create-btn">Sign In</button>

        <button @click="navSignUp" class="create-btn">Sign Up</button>
        <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
      </form>
    </div>
  </div>
</template>

<style scoped>
.sidebar {
  width: 100vw;
  height: 100vh;
  background: #f3f4f6;
  display: flex;
  align-items: center;
  justify-content: center;
}



.create-box {
  width: 100%;
  max-width: 350px;
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

.input {
  width: 100%;
  padding: 0.75rem;
  margin-bottom: 1rem;
  border: 1px solid #ccc;
  border-radius: 8px;
  font-size: 1rem;
  box-sizing: border-box;
}

.create-btn {
  width: 100%;
  margin: 0rem 0rem .75rem;
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

.error {
  margin-top: 0.5rem;
  color: red;
  font-size: 0.9rem;
  text-align: center;
}
</style>
