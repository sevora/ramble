import { useRoutes } from 'react-router-dom';
import routes from './routes'
import useAccount from './hooks/account';

function App() {
  const { isLoggedIn } = useAccount();
  const route = useRoutes( routes({ isLoggedIn }) );
  return (<>{route}</>)
}

export default App;