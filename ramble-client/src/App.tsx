import { useEffect } from 'react';
import { useRoutes } from 'react-router-dom';
import axios from 'axios';

import routes from './routes'
import useAccount from './hooks/account';

/**
 * The application component, separated from the main component
 * for convenience. 
 */
function App() {
  const { isLoggedIn, setUsername, setUserCommonName, setIsLoggedIn } = useAccount();
  const route = useRoutes( routes({ isLoggedIn }) );
  
  useEffect(() => {
    // we attempt to log-in right away if our request for our information works
    const autoLogin = async () => {
      try {
        const account = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/view`, {}, { withCredentials: true });
        const data = account.data as { username: string, userCommonName: string };
        
        setUsername(data.username);
        setUserCommonName(data.userCommonName);
        setIsLoggedIn(true);
      } catch {
        // nothing is to be done here ...
      }
    }

    autoLogin();
  }, []);

  return (
    <>{route}</>
  )
}

export default App;