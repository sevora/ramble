import mysql from 'mysql2/promise';

/**
 * This creates a connection pool which is apparently much more efficient
 * than spawning multiple connections.
 */
const connection: mysql.Pool = mysql.createPool({
    host:       process.env.MYSQL_HOST      || 'localhost',
    user:       process.env.MYSQL_USER      || 'root',
    database:   process.env.MYSQL_DATABASE  || 'ramble',
    password:   process.env.MYSQL_PASSWORD  || '',
    timezone:   '+00:00'     
});

export default connection;