import { useRoutes } from 'react-router-dom';
import routes from './routes'
import useAccount from './hooks/account';

/**
 * The application component, separated from the main component
 * for convenience. 
 */
function App() {
  const { isLoggedIn } = useAccount();
  const route = useRoutes( routes({ isLoggedIn }) );
  
  return (
    <>{route}</>
  )
}

export default App;