import { FC } from 'react';
import { Outlet, useLocation, useNavigate } from 'react-router-dom';

import { IoHome, IoHomeOutline, IoExit, IoExitOutline, IoSearch, IoSearchOutline } from "react-icons/io5";
import { RiUser6Line, RiUser6Fill } from "react-icons/ri";

import useAccount from './hooks/account';
import NavigationButton from './NavigationButton';
import axios from 'axios';

/**
 * This is the root component rendered when the client is logged-in,
 * it mainly has the navigation bar and an outlet for the other parts
 * such as home, search, viewing profiles, viewing posts.
 */
const DashBoard: FC = () => {
    const { username, setUsername, setIsLoggedIn } = useAccount();

    const navigate = useNavigate();
    const location = useLocation();

    // this is used for highlighting which navigation button should be highlighted based on website location
    const getActiveRoute = () => {
        if (location.pathname === '/')
            return 'home';
        if (location.pathname === '/search')
            return 'search';
        if (location.pathname === `/profile/${username}`)
            return 'profile';
        return null;
    }

    const activeRoute = getActiveRoute();

    /**
     * To log-out, we want to clear the global account state and navigate 
     * back to the landing page.
     */
    const logout = async () => {
        await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/logout`, {}, { withCredentials: true });
        navigate('/');
        setUsername('');
        setIsLoggedIn(false);
    }

    return (
        <div className="grid grid-rows-[auto_60px] sm:grid-rows-1 sm:grid-cols-[180px_auto] h-screen">
            {/* This is the navigation bar, on mobile, the icons are down below */}
            <div className="flex items-center flex-row sm:flex-col row-start-2 sm:row-start-1 text-xl border-t-2 pt-5 sm:border-r-2 sm:border-t-0">
                <NavigationButton InActiveIcon={RiUser6Line} ActiveIcon={RiUser6Fill} label='Profile' active={activeRoute === 'profile'} onClick={() => navigate(`/profile/${username}`)} />
                <NavigationButton InActiveIcon={IoHomeOutline} ActiveIcon={IoHome} label='Home' active={activeRoute === 'home'} onClick={() => navigate('/')} />
                <NavigationButton InActiveIcon={IoSearchOutline} ActiveIcon={IoSearch} label='Search' active={activeRoute === 'search'} onClick={() => navigate('/search')} />
                <NavigationButton InActiveIcon={IoExitOutline} ActiveIcon={IoExit} label='Log-Out' onClick={logout} className='sm:mt-auto sm:mb-2' />
            </div>
            <div className='bg-slate-100 overflow-auto' id="dashboard-outlet">
                <Outlet />
            </div>
        </div>
    )
};

export default DashBoard;