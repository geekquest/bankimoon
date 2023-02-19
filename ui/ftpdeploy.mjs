import FtpDeploy from "ftp-deploy";
import { cwd, env } from 'node:process';
import { join } from 'node:path';
const ftpDeploy = new FtpDeploy();

const config = {
    user: env.USER,
    // Password optional, prompted if none given
    password: env.PASSWORD,
    host: env.FTP_HOST,
    port: 21,
    localRoot: join(cwd(), "./dist"),
    remoteRoot: env.FTP_DIR,
    // include: ["*", "**/*"],      // this would upload everything except dot files
    include: ["*", "dist/*", ".*"],
    // e.g. exclude sourcemaps, and ALL files in node_modules (including dot files)
    exclude: [
        // "dist/**/*.map",
        "node_modules/**",
        "node_modules/**/.*",
        ".git/**"
    ],
    // delete ALL existing files at destination before uploading, if true
    deleteRemote: false,
    // Passive mode is forced (EPSV command is not sent)
    forcePasv: true,
    // use sftp or ftp
    sftp: false,
};

ftpDeploy
    .deploy(config)
    .then((res) => console.log("finished:", res))
    .catch((err) => console.log(err));
