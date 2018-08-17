package Classes;


import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CookiesProcessing {




    public static String getCookie(HttpServletRequest req, CookieName cookieName) {

        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (cookieName.toString().equalsIgnoreCase(c.getName())) return c.getValue();
            }
        }
        return null;
    }

    public static Cookie setCookie(HttpServletResponse resp, CookieName name, String value, String domain, int maxAge) {
        Cookie cookie = new Cookie(name.toString(), value);
        cookie.setDomain(domain);
        cookie.setMaxAge(maxAge);

        // добавляем куки в ответ чтобы браузер их у себя разместил
        resp.addCookie(cookie);

        return cookie;
    }

    public static void killCookies(HttpServletRequest req, HttpServletResponse resp) {
        killCookies(req, resp, CookieName.values());
    }

    public static void killCookies(HttpServletRequest req, HttpServletResponse resp, CookieName... cookiesName) {
        Cookie[] cookies = req.getCookies();
        for (CookieName cookieName : cookiesName) {
            for (Cookie c : cookies) {
                if (cookieName.toString().equalsIgnoreCase(c.getName())) {
                    c.setMaxAge(0);
                    resp.addCookie(c);
                }
            }
        }
    }

    public enum CookieName {
        WOT_USERNAME,
        WOT_USER_ID,
        WOT_TOKEN,
        WOT_EXPIRES
    }


}
