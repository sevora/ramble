import { Outlet } from "react-router-dom";

const Landing = () => {
    return (
        <div>
            <div className="flex justify-center flex-col m-auto h-screen bg-slate-100">
                <div className='bg-white p-5 mx-auto my-10 rounded-lg shadow-2xl w-5/6 sm:w-3/5 md:w-2/5'>
                    <h1 className='text-xl mb-2.5 text-left text-2xl font-semibold'>Welcome to Ramble!</h1>
                    <Outlet />
                </div>
            </div>
        </div>
    );
}

export default Landing;