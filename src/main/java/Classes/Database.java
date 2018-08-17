package Classes;

import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.json.JsonString;
import javax.validation.constraints.Null;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.sql.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.Properties;


public class Database {

    private static String url = "jdbc:postgresql:tdb";
    private static Properties props = new Properties();
    private static Connection conn;

    static {
//        props.setProperty("user", "postgres");
//        props.setProperty("password", "123");
//        props.setProperty("charSet ", "UTF8");
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        initConn();
    }

    public static boolean initConn() {

        try {
            if (conn == null || conn.isClosed()) {
//                conn = DriverManager.getConnection(url, props);
                conn = DriverManager.getConnection("jdbc:postgresql://127.0.0.1:5432/develop_db","wolfio", "qwerty");
            }
        } catch (SQLException e) {
            return false;
        }
        return true;
    }

    public static Connection getConn() throws SQLException {
        if (conn == null || conn.isClosed()) //перестраховка
            initConn();
        return conn;
    }

    public static String getTimeString(long time) {
        int dif_min;
        String stringTime = "";
        dif_min = (int) (System.currentTimeMillis() - time) / 1000 / 60;
        //https://javatalks.ru/topics/39523
        if (dif_min == 0) stringTime = "только что";
        else if (dif_min > 0 && dif_min < 60) stringTime = dif_min + " мин. назад";
        else if (dif_min == 60) stringTime = "час назад";
        else if (dif_min > 60) stringTime = "более часа назад";

//        if (dif_min > 60) stringTime = (dif_min / 60) + " часов " + (dif_min % 60) + " минут назад";
//        else stringTime = (dif_min + " минут назад");
        return stringTime;
    }

    public static ArrayList<String> getActualAd() {
        ArrayList<String> result = new ArrayList<String>();
        String sql =
                "select account_id,nickname,cr_date,text,tags,id " +
                        "from bboard " +
                        "order by cr_date";
        try {

            ResultSet rs = getConn()
                    .createStatement()
                    .executeQuery(sql);
            while (rs.next()) {
                result.add(rs.getString(1));
                result.add(rs.getString(2));
                result.add(getTimeString(rs.getTimestamp(3).getTime()));
                result.add(rs.getString(4));
                result.add(rs.getString(5));
                result.add(rs.getString(6));
            }
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public static void addNewAd(int accId, int duration, String text, String nickname) throws SQLException {
        String sql = "" +
                "INSERT INTO bboard (account_id,  duration, text, tags, nickname) " +
                "VALUES (" + accId + "," + duration + ",'" + text + "',NULL ,'" + nickname + "')" +
                "";
//        System.out.println("Sql: " + sql);
        getConn().createStatement().executeUpdate(sql);
    }


    /* true - уже есть отклик
    * false - еще нет отклика*/
    public static boolean alreadyResponded(int adNum, int accountId) {
        String sql = "" +
                "select count(1) " +
                "from bboard a1,responds a2 " +
                "where a1.id = a2.resp_ref " +
                "and a1.id = " + adNum +
                " and a2.user_id = " + accountId;
        // FIXME: 02.12.2017 При добавлении отклика в будущем надо учитывать актуальность объявы
        try {
            ResultSet rs = getConn()
                    .createStatement()
                    .executeQuery(sql);
            rs.next();
            int cntResponds = rs.getInt(1);
            if (cntResponds == 0)
                return false;
            else return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static void addRespond(int adNum, int accountId, String username, int battleCnt, double winRate, int globalRate) throws SQLException {
        if (alreadyResponded(adNum, accountId)) return; // FIXME: 01.01.2018 Придумать как уведомлять всплывалкой об этом

        String sql =
                "INSERT INTO responds(resp_ref, username, user_id, battle_count, win_rate, own_rate)" +
                        "VALUES (" + adNum + ",'" + username + "'," + accountId + "," + battleCnt + "," + winRate + "," + globalRate + ")";
        System.out.println("Sql: " + sql);
        getConn().createStatement().executeUpdate(sql);

    }

    public static ArrayList<String> getRespondsList(int adId,Integer [] colsCnt) throws SQLException {
        ArrayList<String> result = new ArrayList<>();
        String sql =
                "select username,user_id,battle_count,win_rate,own_rate " +
                        "from responds " +
                        "where resp_ref = " +adId+
                        "order by cr_date";

        ResultSet rs = getConn()
                .createStatement()
                .executeQuery(sql);
        colsCnt[0] = rs.getMetaData().getColumnCount(); //чтобы сохранить значение для вызываемой функции
        while (rs.next()) {
            result.add(rs.getString(1));
            result.add(rs.getString(2));
            result.add(rs.getString(3));
            result.add(rs.getString(4));
            result.add(rs.getString(5));
        }
        return result;
    }

    public static void main(String[] args) {


//        Byte.valueOf("SleEpEe");
        String accountId = null;
        System.out.println(accountId==null ? null : Long.parseLong(accountId));
        LoginInfo loginInfo = new LoginInfo();

    }

}

