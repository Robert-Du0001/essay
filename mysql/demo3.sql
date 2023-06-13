/**
 * 搜索并替换json的值
 * @param Json data 要处理的原数据
 * @param CHAR(3) one_or_all 替换一次还是替换全部
 *  one 替换一次
 *  all 替换全部
 * @param VARCHAR(200) search_str 要搜索的字符
 * @param VARCHAR(50) path 字符所在的路径
 * @param VARCHAR(200) replace_str 要替换的字符
 * @return Json 处理后的新数据
 */

SET GLOBAL log_bin_trust_function_creators = 1;
DROP FUNCTION IF EXISTS zmsun_json_search_replace;
DELIMITER $$
CREATE FUNCTION zmsun_json_search_replace(data JSON, one_or_all CHAR(3), search_str VARCHAR(200), path VARCHAR(50), replace_str VARCHAR(200)) RETURNS JSON
BEGIN
    DECLARE result_path JSON DEFAULT "[]";
    DECLARE result_path_len INT UNSIGNED DEFAULT 0;
    DECLARE count INT UNSIGNED DEFAULT 0;

    SET result_path = JSON_SEARCH(data, one_or_all, search_str, null, path);

    IF result_path IS NOT NULL THEN
        SET result_path_len = JSON_LENGTH(result_path);

        WHILE count < result_path_len DO
            SET data = JSON_REPLACE(data, JSON_UNQUOTE(JSON_EXTRACT(result_path, CONCAT("$[", count, "]"))), replace_str);

            SET count = count + 1;
        END WHILE;
    END IF;
    
    RETURN data;
END $$
DELIMITER ;
