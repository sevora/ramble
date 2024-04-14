import axios from 'axios';
import { FC, useEffect, useState } from 'react';
import { useInView } from 'react-intersection-observer';
import { useParams } from 'react-router-dom';
import Post from './Post';

const ViewProfile: FC = () => {
    const { username } = useParams<{ username: string }>();
    
    const [posts, setPosts] = useState<{ postId: string }[]>([]);

    const [page, setPage] = useState<number>(0);
    const [hasNextPage, setHasNextPage] = useState<boolean>(true);

    const [moreButtonReference, inView ] = useInView({ root: document.querySelector('#dashboard-outlet'), initialInView: true, delay: 1000, threshold: 1.0 });

    /**
     * Use this to get the posts at category and page
     * @param category the category of the post
     * @param page the current page
     * @returns the postIds in an array
     */
    const getPosts = async (page: number) => {
        const response = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/post/list`, { username, page }, { withCredentials: true });
        return response.data.posts as { postId: string }[];
    }
    
    /**
     * This is the logic to load more posts through
     * infinite scrolling. Had wasted time figuring out a lot of things here.
     */
    const loadMorePosts = async () => {
        if (!hasNextPage) return;

        const more = await getPosts(page);
    
        if (more.length > 0) {
            setPosts([...posts, ...more]);
            setPage(page + 1);
        } else {
            setHasNextPage(false);
        }
    }

     // when the next button is inView (initially it is) we load more posts
    useEffect(() => {
        if (inView) 
            loadMorePosts();
    }, [ page, inView ]);

    return (
        <div>
            <div className='bg-white rounded-tl-none rounded-lg'>   
                {
                    posts.map(post => {
                        const { postId } = post;
                        return <Post key={postId} postId={postId} className='hover:bg-neutral-100' />
                    })
                }
                <div className='w-full text-center p-5 hover:bg-neutral-200' ref={moreButtonReference}>{hasNextPage ? 'Loading' : 'No more posts'}</div>
            </div>
        </div>
    );
}

export default ViewProfile;