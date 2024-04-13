import { FC } from 'react';
import { useParams } from 'react-router-dom';

const ViewProfile: FC = () => {
    const { username } = useParams<{ username: string }>();

    return (
        <>Profile</>
    );
}

export default ViewProfile;