import { Navigate, RouteObject } from 'react-router-dom';

import DashBoard from './DashBoard';
import Landing from './Landing';
import LogIn from './LogIn';
import SignUp from './SignUp';

interface RoutesParameters {
    isLoggedIn: boolean;
}

/**
 * This outlines the route, a function that returns the routes based on parameters, intended for `useRoutes`.
 * @returns an array of `RouteObject`.
 */
const routes = ({ isLoggedIn }: RoutesParameters): RouteObject[] => [
    {
        path: '/',
        // <DashBoard /> has an <Outlet /> component inside which renders the child routes here
        element: isLoggedIn ? <DashBoard /> : <Navigate to="/welcome" />,
        children: [
            { path: '/', element: <div>You are logged-in</div> }
        ]
    },
    {
        path: '/welcome',
         // <Landing /> has an <Outlet /> component inside which renders the child routes here
        element: !isLoggedIn ? <Landing /> : <Navigate to="/" />,
        children: [
            { path: '/', element: <LogIn /> },
            { path: '/signup', element: <SignUp /> }
        ]
    }

]

export default routes;