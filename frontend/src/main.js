import { Amplify } from 'aws-amplify';
import { createApp } from 'vue';
import App from './App.vue';
import router from './router'; 
import { amplifyConfig } from './amplifyConfig'; 

Amplify.configure(amplifyConfig);

const app = createApp(App);
app.use(router);
app.mount('#app');