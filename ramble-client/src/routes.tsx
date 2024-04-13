import { Navigate, Outlet, RouteObject } from 'react-router-dom';

import LogIn from './LogIn';

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
        element: isLoggedIn ? <Outlet /> : <Navigate to="/login" />,
        children: [
            { path: '/', element: <div>You are logged-in</div> }
        ]
    },
    {
        path: '/login',
        element: !isLoggedIn ? <LogIn /> : <Navigate to="/" />
    }

]

export default routes;