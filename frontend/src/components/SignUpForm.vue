<script setup>
import { signUp, confirmSignUp } from '@aws-amplify/auth';
import { useRouter } from 'vue-router';
import { ref } from 'vue';

const router = useRouter();
const username = ref('');
const password = ref('');
const email = ref('');
const phone = ref('');
const errorMessage = ref('');
const successMessage = ref('');
const MFAcheck = ref(false);
const pendingUsername = ref('');
const code = ref('');


async function register() {
  try {
   const result = await signUp({
  username: username.value,
  password: password.value,
  options: {
    userAttributes: {
      email: email.value,
      phone_number: phone.value,
    },
  },
});
    pendingUsername.value = username.value;
    MFAcheck.value = true;
  } catch (err) {
    console.error('Sign up error:', err);
    errorMessage.value = err.message || 'An error occurred during sign up.';
  }
}


async function submitCode() {
  try {
    await confirmSignUp({
      username: pendingUsername.value,
      confirmationCode: code.value
    });
    successMessage.value = 'Account confirmed!';
    router.push('/');
  } catch (err) {
    router.push("/")
  }
}
</script>

<template>
  <div v-if="!MFAcheck" class="sidebar">
    <div class="create-box">
      <h2 class="header">Sign Up</h2>
      <form @submit.prevent="register">
        <input v-model="username" class="input" type="text" placeholder="Username" required />
        <input v-model="email" class="input" type="email" placeholder="Email" required />
        <input v-model="phone" type="tel" placeholder="Phone (+1234567890)" required class="input" />
        <input v-model="password" class="input" type="password" placeholder="Password" required />
        <button class="create-btn" type="submit">Create Account</button>
        <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
        <p v-if="successMessage" class="success">{{ successMessage }}</p>
      </form>
    </div>
  </div>

    <div v-else class="sidebar">
    <div class="create-box">
      <h2 class="header">Enter MFA Code</h2>
      <form @submit.prevent="submitCode" style="width: 100%;">
        <input v-model="code" class="input" type="text" placeholder="Ex: 123456" required />
        <button class="create-btn" type="submit">Verify</button>
        <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
        <p v-if="successMessage" class="success">{{ successMessage }}</p>
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

.success {
  margin-top: 0.5rem;
  color: green;
  font-size: 0.9rem;
  text-align: center;
}
</style>
