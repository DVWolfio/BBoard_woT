package Classes;

import java.util.Date;

public class LoginInfo {
    private String status;

    private String access_token;
    private Date expires_at;
    private long account_id;
    private String nickname;

    private String codeErr;
    private String messageErr;
    public static String domainName;
    public static int serverPort;

    public LoginInfo() {

    }

    public String getStatus() {
        return status;
    }
    public Date getExpires_at() {
        return expires_at;
    }
    public long getAccount_id() {
        return account_id;
    }
    public String getNickname() {
        return nickname;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setAccess_token(String access_token) {
        this.access_token = access_token;
    }

    public void setExpires_at(Date expires_at) {
        this.expires_at = expires_at;
    }

    public void setAccount_id(long account_id) {
        this.account_id = account_id;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getAccess_token() {
        return access_token;
    }

    public LoginInfo(String status, String access_token, Date expires_at, long account_id, String nickname) {
        this.status = status;
        this.access_token = access_token;
        this.expires_at = expires_at;
        this.account_id = account_id;
        this.nickname = nickname;
    }

    public LoginInfo(String status, String codeErr, String messageErr) {
        this.status = status;
        this.codeErr = codeErr;
        this.messageErr = messageErr;
    }
    public static String getApplicationId(){
        return "4e67660611202f132151e26f8cce5a27";
    }

    public static void setDomainName(String domainName) {
        LoginInfo.domainName = domainName;
    }

    public static String getDomainName() {

        return domainName;
    }

    public static void setServerPort(int serverPort) {
        LoginInfo.serverPort = serverPort;
    }

    public static int getServerPort() {

        return serverPort;
    }
}
