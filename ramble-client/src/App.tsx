import { useEffect, useState } from 'react';
import { useLocation, useNavigate, useRoutes } from 'react-router-dom';
import axios from 'axios';

import routes from './routes'
import useAccount from './hooks/account';

/**
 * The application component, separated from the main component
 * for convenience. 
 */
function App() {
  const { isLoggedIn, setUsername, setUserCommonName, setIsLoggedIn } = useAccount();
  
  const location = useLocation();
  const navigate = useNavigate();

  // this is a fix to the issue where a logged-in user starts with a logged-out state, gets redirected to /welcome, /welcome redirects to /
  // tldr; used to recover last path when log-in is confirmed
  const [ lastPath ] = useState<string>(location.pathname);
  const route = useRoutes( routes({ isLoggedIn }) );
  
  useEffect(() => {
    // we attempt to log-in right away if our request for our information works
    const autoLogin = async () => {
      try {
        const account = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/view`, {}, { withCredentials: true });
        const data = account.data as { username: string, userCommonName: string };
        const c = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/follower/list`, { category: "follower", page: 0 }, { withCredentials: true });
        console.log(c.data)
        setUsername(data.username);
        setUserCommonName(data.userCommonName);
        setIsLoggedIn(true);
        navigate(lastPath);
      } catch {
        setIsLoggedIn(false);
      }
    }

    autoLogin();
  }, []);

  return (
    <>{route}</>
  )
}

export default App;