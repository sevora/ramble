import { FC } from 'react';
import { Outlet } from 'react-router-dom';

const DashBoard: FC = () => {
    return (
        <div>
            <h1>Welcome</h1>
            <Outlet />
        </div>
    )
};

export default DashBoard;