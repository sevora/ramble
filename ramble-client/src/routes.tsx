import { Navigate, RouteObject } from 'react-router-dom';

import DashBoard from './DashBoard';
import Home from './Home';
import ViewProfile from './ViewProfile';
import ViewFollower from './ViewFollower';
import ViewPost from './ViewPost';
import Search from './Search';
import Landing from './Landing';
import LogIn from './LogIn';
import SignUp from './SignUp';
import NotFound from './NotFound';
import UpdateProfile from './UpdateProfile';

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
            { path: '/', element: <Home /> },
            { path: '/update', element: <UpdateProfile /> },
            { path: '/profile/:username', element: <ViewProfile /> },
            // this specific route should only accept either follower or following
            { path: '/profile/:username/:category', element: <ViewFollower /> },
            { path: '/post/:postId', element: <ViewPost /> },
            { path: '/search', element: <Search /> }
        ]
    },
    {
        path: '/welcome',
         // <Landing /> has an <Outlet /> component inside which renders the child routes here
        element: !isLoggedIn ? <Landing /> : <Navigate to="/" />,
        children: [
            { path: '/welcome', element: <LogIn /> },
            { path: '/welcome/signup', element: <SignUp /> }
        ]
    },
    {
        path: '/*',
        element: <NotFound />
    }

]

export default routes;