-- industries 字段值为 0101|0102|0302|010301|010302
-- 判断02是否是在以industries字段中的每一项开头
SELECT * FROM `zmsun_s_base_member_expect_job` WHERE search_by_set_item('02', `industries`, '|')

/*
 * 函数定义
 * 如果提示“This function has none of DETERMINISTIC, NO SQL, or READS SQL DATA...”，意思是没开启函数创建，解决方法：
 * 第一种（本次会话有效）：SET GLOBAL log_bin_trust_function_creators = 1;
 * 第二种（长期有效）：在my.cnf里面设置 log-bin-trust-function-creators=1，并重启mysql。（然而并没有用，还是第一种好）
 *
 * a 为搜索的字符串
 * b 为被搜索的字符串
 * c 为分割符
 *
 * 说明：虽然此函数功能看似狭窄，但是分割字符以及单独匹配的思路可以借鉴（本来就是我想出来的，借鉴这个词。。。，我借我自己？）
 */
SET GLOBAL log_bin_trust_function_creators = 1;
DROP FUNCTION IF EXISTS search_by_set_item;
DELIMITER $$
CREATE FUNCTION search_by_set_item(a varchar(20), b VARCHAR(100), lim CHAR(1)) RETURNS BOOLEAN
BEGIN
    DECLARE a_a CHAR(20) DEFAULT '';
    DECLARE b_len INT UNSIGNED DEFAULT Length(b);
    DECLARE count INT UNSIGNED DEFAULT 1;
    DECLARE c CHAR(1);

    WHILE count <= b_len DO
        SET c = SubString(b, count, 1);
        IF c = '|' THEN
            IF LOCATE(a, a_a) = 1 THEN
                RETURN TRUE;
            END IF;

            SET a_a = '';
        ELSE
            SET a_a = Concat(a_a, c);
        END IF;
 
        SET count = count + 1;
    END WHILE;

    RETURN FALSE;
END $$
DELIMITER ;
