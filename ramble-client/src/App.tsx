import axios from 'axios';
import { useState } from 'react';

function App() {
  const [ username, setUsername ] = useState<string>('');
  const [ password, setPassword] = useState<string>('');
  const [ result, setResult ] = useState<string>();

  const login = async () => {
    try {
      const response = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/update`, { userCommonName: 'Ralph', username, password }, { withCredentials: true });
      console.log(response)
      // if (response.status === 200) {
        // const response2 = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/update`, { biography: "Hello" }, { withCredentials: true });
        // setResult(JSON.stringify(response2.data));
      // }
      
    } catch {
      setResult('The username or password is incorrect.')
    }
  }

  return (
    <>
      <input type='text' value={username} onChange={e => setUsername(e.target.value)}></input>
      <input type='password' value={password} onChange={e => setPassword(e.target.value)}></input>
      <button onClick={login}>Log-In!</button>
      <div>{result}</div>
    </>
  )
}

export default App
