/**
 * 删除集合(以逗号分割的字符串)中的元素，
 * 核心思想是把集合字符串以逗号分隔成json的数据，再循环遍历，删除要指定的元素。
 * 此思路比纯用字符串操作的可扩展性要强些，可以添加去重、多元素删除等功能。
 */

SET GLOBAL log_bin_trust_function_creators = 1;
DROP FUNCTION IF EXISTS zmsun_del_in_set;
DELIMITER $$
CREATE FUNCTION zmsun_del_in_set(a VARCHAR(20), b VARCHAR(500)) RETURNS VARCHAR(500)
BEGIN
    DECLARE b_tmp_item VARCHAR(500) DEFAULT '';
    DECLARE b_len INT UNSIGNED DEFAULT Length(b);
    
    DECLARE count INT UNSIGNED DEFAULT 1;
    DECLARE c CHAR(1);

    DECLARE data JSON DEFAULT "[]";
    DECLARE data_item_index INT UNSIGNED DEFAULT 0;
    DECLARE data_str VARCHAR(500) DEFAULT '';
    
    WHILE count <= b_len DO
        SET c = SUBSTRING(b, count, 1);

        IF c = ',' OR count = b_len THEN
            IF count = b_len THEN
                SET b_tmp_item = CONCAT(b_tmp_item, c);
            END IF;

            IF a <> b_tmp_item THEN
                SET data = JSON_SET(data, CONCAT("$[", data_item_index, "]"), b_tmp_item);
                SET data_item_index = data_item_index + 1;
            END IF;

            SET b_tmp_item = '';
        ELSE
            SET b_tmp_item = CONCAT(b_tmp_item, c);
        END IF;

        SET count = count + 1;
    END WHILE;

    SET count = 0, data_item_index = data_item_index - 1;

    WHILE count <= data_item_index DO

        IF count = data_item_index THEN
            SET data_str = CONCAT(data_str, JSON_UNQUOTE(JSON_EXTRACT(data, CONCAT("$[", count, "]"))));
        ELSE
            SET data_str = CONCAT(data_str, JSON_UNQUOTE(JSON_EXTRACT(data, CONCAT("$[", count, "]"))), ",");
        END IF;

        SET count = count + 1;
    END WHILE;

    RETURN data_str;
END $$
DELIMITER ;