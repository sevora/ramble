import { FC } from 'react';
import { useParams } from 'react-router-dom';

const Profile: FC = () => {
    const { username } = useParams<{ username: string }>();

    return (
        <></>
    );
}

export default Profile;