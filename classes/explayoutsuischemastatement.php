<?php
/**
 * Which explayouts_* table a statement of a schema file belongs to, so the setup page can leave the statements of a
 * table that exists already alone: its indexes (CREATE INDEX ... ON table), keys (ALTER TABLE table ...), sequences
 * (PostgreSQL table_id_seq, Oracle se_table) and Oracle triggers (... BEFORE INSERT ON table), not only CREATE TABLE.
 * Index and trigger names are never taken for the table: Oracle names them after it (explayouts_share_idx_token).
 *
 * @license GPL-2.0-or-later
 */
class expLayoutsUiSchemaStatement
{
    /**
     * @param string $statement one statement of a schema file
     * @return string the table, lower case, or '' when the statement names no explayouts_* table
     */
    public static function tableOf( $statement )
    {
        $statement = (string)$statement;
        $patterns = array(
            '/\bON\s+["`]?(explayouts_\w+)/i',
            '/\bTABLE\s+(?:ONLY\s+)?(?:IF\s+(?:NOT\s+)?EXISTS\s+)?["`]?(explayouts_\w+)/i',
            '/\bSEQUENCE\s+(?:IF\s+NOT\s+EXISTS\s+)?["`]?(?:se_(explayouts_\w+)|(explayouts_\w+?)_id_seq\b)/i',
        );
        foreach ( $patterns as $pattern )
        {
            if ( preg_match( $pattern, $statement, $m ) )
            {
                $table = isset( $m[2] ) && $m[2] !== '' ? $m[2] : $m[1];
                return strtolower( trim( $table, '"`' ) );
            }
        }
        return '';
    }
}
