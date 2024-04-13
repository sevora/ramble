import { FC } from 'react';
import { Outlet } from 'react-router-dom';

const DashBoard: FC = () => {
    return (
        <div className="grid grid-rows-[auto_60px] sm:grid-rows-1 sm:grid-cols-[180px_auto] h-screen">
            <div className="bg-blue-100 row-start-2 sm:row-start-1 text-xl">
                
            </div>
            <div className="bg-red-100">
                <Outlet />
            </div>
        </div>
    )
};

export default DashBoard;