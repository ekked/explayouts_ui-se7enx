<?php
/**
 * The targets and conditions of a mapping as posted by the rule forms (TargetType[]/TargetValue[],
 * ConditionType[]/ConditionValue[]): only the types the resolver (expLayoutsResolver) knows are kept, everything else
 * is reported back so the view can say what it did not save.
 *
 * @license GPL-2.0-or-later
 */
class expLayoutsUiRuleInput
{
    /** The target types the forms offer */
    const TARGET_TYPES = array( 'path', 'path_prefix', 'path_regex', 'node', 'subtree', 'route' );

    /** The condition types the forms offer */
    const CONDITION_TYPES = array( 'siteaccess', 'class', 'query_parameter', 'route_parameter', 'time' );

    /**
     * Target types that may be saved: every type the resolver knows (expLayoutsResolver::TARGET_TYPES, see
     * storableTargetTypes()); this list for an explayouts without that constant. The offered ones plus those the
     * resolver still reads from older rules, and the module targets of the admin layouts, which a rule saved
     * through these forms must keep.
     */
    const STORABLE_TARGET_TYPES = array( 'path', 'path_prefix', 'path_info_prefix', 'path_regex', 'node', 'subtree', 'route',
                                         'module', 'module_view' );

    /**
     * Condition types that may be saved: every type the resolver knows (expLayoutsResolver::CONDITION_TYPES, see
     * storableConditionTypes()); this list for an explayouts without that constant. The offered ones plus
     * content_type, the older name of class. Not ibexa_content_type: only a resolver that lists its types matches
     * it, so an older one would keep a condition that never applies.
     */
    const STORABLE_CONDITION_TYPES = array( 'siteaccess', 'class', 'content_type', 'query_parameter',
                                            'route_parameter', 'time' );

    /** The target types that may be saved, from the resolver when it lists them */
    public static function storableTargetTypes()
    {
        return self::resolverTypes( 'TARGET_TYPES', self::STORABLE_TARGET_TYPES );
    }

    /** The condition types that may be saved, from the resolver when it lists them */
    public static function storableConditionTypes()
    {
        return self::resolverTypes( 'CONDITION_TYPES', self::STORABLE_CONDITION_TYPES );
    }

    protected static function resolverTypes( $constant, array $fallback )
    {
        if ( class_exists( 'expLayoutsResolver' ) && defined( 'expLayoutsResolver::' . $constant ) )
            return constant( 'expLayoutsResolver::' . $constant );
        return $fallback;
    }

    /**
     * Pairs the posted types with their values. Empty types are skipped silently (an empty row), unknown ones and
     * values that are not strings are left out and listed in $rejected.
     *
     * @param mixed  $types    the posted type list
     * @param mixed  $values   the posted value list, by the same index
     * @param array  $known    the types that may be saved
     * @param array &$rejected receives each type that was left out (as text, for the message)
     * @return array list of array( 'type' => ..., 'value' => ... )
     */
    public static function collect( $types, $values, array $known, array &$rejected )
    {
        $types = is_array( $types ) ? array_values( $types ) : array();
        $values = is_array( $values ) ? array_values( $values ) : array();
        $result = array();
        foreach ( $types as $i => $type )
        {
            $value = isset( $values[$i] ) ? $values[$i] : '';
            if ( !is_string( $type ) || !is_string( $value ) )
            {
                $rejected[] = is_string( $type ) ? $type : '?';
                continue;
            }
            $type = trim( $type );
            if ( $type === '' )
                continue;
            if ( !in_array( $type, $known, true ) )
            {
                $rejected[] = $type;
                continue;
            }
            $result[] = array( 'type' => $type, 'value' => trim( $value ) );
        }
        return $result;
    }

    /** The posted targets, see collect() */
    public static function targets( $types, $values, array &$rejected )
    {
        return self::collect( $types, $values, self::storableTargetTypes(), $rejected );
    }

    /** The posted conditions, see collect() */
    public static function conditions( $types, $values, array &$rejected )
    {
        return self::collect( $types, $values, self::storableConditionTypes(), $rejected );
    }

    /**
     * The message for the types left out, or '' when nothing was left out
     * @param array $rejected
     * @return string
     */
    public static function rejectedMessage( array $rejected )
    {
        if ( !$rejected )
            return '';
        return ezpI18n::tr( 'design/admin/explayouts_ui/rule_list', 'Unknown target or condition types were not saved: %types', null,
                            array( '%types' => implode( ', ', array_unique( $rejected ) ) ) );
    }
}
