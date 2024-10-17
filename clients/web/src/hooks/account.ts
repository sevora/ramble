import { create } from 'zustand';

/**
 * This is the information best kept, that is used across
 * the site components.
 */
interface AccountState {
  /**
   * The username is an all lowercase, no space, alphanumeric and underscore only
   * string that may uniquely identify a user.
   */
    username: string;

    /**
     * Tells if the user is logged in or not.
     */
    isLoggedIn: boolean;

    /**
     * Use this to set the username of the client.
     * @param username the username
     */
    setUsername: (username: string) => void;

    /**
     * Use this to set whether the client is logged in or not.
     * @param isLoggedIn true for logged in, false otherwise
     */
    setIsLoggedIn: (isLoggedIn: boolean) => void;
}

/**
 * This hook is for managing account state
 */
const useAccount = create<AccountState>()(set => ({
  username: '',
  isLoggedIn: false,
  
  setUsername: (username) => set({ username }),
  setIsLoggedIn: (isLoggedIn) => set({ isLoggedIn }),
}));

export default useAccount;