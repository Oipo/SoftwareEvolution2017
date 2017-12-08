public class TestTokenizer {
	public static synchronized Database lookupDatabaseObject(String type, String path) {

        Object  key = path;
        HashMap databaseMap;

        if (type == DatabaseURL.S_FILE) {
            databaseMap = fileDatabaseMap;
            key         = filePathToKey(path);
        } else if (type == DatabaseURL.S_RES) {
            databaseMap = resDatabaseMap;
        } else if (type == DatabaseURL.S_MEM) {
            databaseMap = memDatabaseMap;
        } else {
            throw (Error.runtimeError(ErrorCode.U_S0500, "DatabaseManager"));
        }

        return (Database) databaseMap.get(key);
    }
	
	public static synchronized Database lookupDatabaseObject2(int type, boolean path) {

        Object  key = path;
        HashMap databaseMap;

        if (type == DatabaseURL.S_PATH) {
            databaseMap = fileDatabaseMap;
            key         = filePathToKey(path);
        } else if (type == DatabaseURL.S_RES) {
            databaseMap = resDatabaseMap;
        } else if (type == DatabaseURL.S_MEM) {
            databaseMap = memDatabaseMap;
        } else {
            throw (Error.runtimeError(ErrorCode.U_S0500, 1));
        }

        return (Database) databaseMap.get(key);
    }
}