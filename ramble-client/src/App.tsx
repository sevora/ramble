import { useEffect, useState } from 'react';
import { useLocation, useNavigate, useRoutes } from 'react-router-dom';
import axios from 'axios';

import routes from './routes'
import useAccount from './hooks/account';

import Loader from './Loader';

/**
 * The application component, separated from the main component
 * for convenience. 
 */
function App() {
  const { isLoggedIn, setUsername, setIsLoggedIn } = useAccount();
  const [ isLoading, setIsLoading ] = useState<boolean>(true);
  
  const location = useLocation();
  const navigate = useNavigate();

  // this is a fix to the issue where a logged-in user starts with a logged-out state, gets redirected to /welcome, /welcome redirects to /
  // tldr; used to recover last path when log-in is confirmed
  const [ lastPath ] = useState<string>(location.pathname);
  const route = useRoutes( routes({ isLoggedIn }) );
  
  useEffect(() => {
    // we attempt to log-in right away if our request to view our information works
    async function autoLogin() {
      try {
        const account = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/view`, {}, { withCredentials: true });
        const data = account.data as { username: string, userCommonName: string };
        setUsername(data.username);
        setIsLoggedIn(true);
        navigate(lastPath);
      } catch {
        // if we aren't logged in, the endpoint should fail
        setIsLoggedIn(false);
      }

      setIsLoading(false);
    }

    autoLogin();
  }, []);

  return (
    <>
    {
      !isLoading ? route : (
        // we want to display a loader if it hasn't loaded yet
        <div className='flex items-center justify-center w-screen h-screen'>
          <Loader />
        </div>
      )
    }
    </>
  )
}

export default App;