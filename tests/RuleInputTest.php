<?php
/**
 * The targets and conditions a rule form posts: only types the resolver knows are saved, the rest is reported.
 *
 * @license GPL-2.0-or-later
 */
use PHPUnit\Framework\TestCase;

class RuleInputTest extends TestCase
{
    public function testKnownTypesAreKeptWithTheirValues()
    {
        $rejected = array();
        $targets = expLayoutsUiRuleInput::targets( array( 'node', ' path ', 'subtree' ), array( '2', ' /about ', '' ), $rejected );
        $this->assertSame( array( array( 'type' => 'node', 'value' => '2' ), array( 'type' => 'path', 'value' => '/about' ),
                                  array( 'type' => 'subtree', 'value' => '' ) ), $targets );
        $this->assertSame( array(), $rejected );
    }

    public function testUnknownTypesAreLeftOutAndReported()
    {
        $rejected = array();
        $targets = expLayoutsUiRuleInput::targets( array( 'node', '<img src=x onerror=alert(1)>', 'class' ), array( '2', 'x', 'y' ), $rejected );
        $conditions = expLayoutsUiRuleInput::conditions( array( 'siteaccess', 'node', 'time' ), array( '["site"]', '3', '' ), $rejected );
        $this->assertSame( array( array( 'type' => 'node', 'value' => '2' ) ), $targets );
        $this->assertSame( array( 'siteaccess', 'time' ), array_column( $conditions, 'type' ) );
        $this->assertSame( array( '<img src=x onerror=alert(1)>', 'class', 'node' ), $rejected );
        $this->assertSame( 'Unknown target or condition types were not saved: <img src=x onerror=alert(1)>, class, node',
                           expLayoutsUiRuleInput::rejectedMessage( $rejected ) );
    }

    public function testEmptyRowsAreSkippedSilently()
    {
        $rejected = array();
        $this->assertSame( array(), expLayoutsUiRuleInput::targets( array( '', '  ' ), array( 'a', 'b' ), $rejected ) );
        $this->assertSame( array(), $rejected );
        $this->assertSame( '', expLayoutsUiRuleInput::rejectedMessage( $rejected ) );
    }

    public function testValuesThatAreNoStringsAreRejected()
    {
        $rejected = array();
        $this->assertSame( array(), expLayoutsUiRuleInput::targets( array( 'node', array( 'x' ) ), array( array( '2' ), 'y' ), $rejected ) );
        $this->assertSame( array( 'node', '?' ), $rejected );
        $rejected = array();
        $this->assertSame( array(), expLayoutsUiRuleInput::conditions( 'time', 'x', $rejected ), 'not a list' );
    }

    public function testOlderTypesTheResolverReadsCanBeSavedButAreNotOffered()
    {
        $rejected = array();
        $this->assertCount( 1, expLayoutsUiRuleInput::targets( array( 'path_info_prefix' ), array( '/x' ), $rejected ) );
        $this->assertCount( 1, expLayoutsUiRuleInput::conditions( array( 'content_type' ), array( '["article"]' ), $rejected ) );
        $this->assertSame( array(), $rejected );
        $this->assertNotContains( 'path_info_prefix', expLayoutsUiRuleInput::TARGET_TYPES );
        $this->assertNotContains( 'content_type', expLayoutsUiRuleInput::CONDITION_TYPES );
        $this->assertEmpty( array_diff( expLayoutsUiRuleInput::TARGET_TYPES, expLayoutsUiRuleInput::STORABLE_TARGET_TYPES ) );
        $this->assertEmpty( array_diff( expLayoutsUiRuleInput::CONDITION_TYPES, expLayoutsUiRuleInput::STORABLE_CONDITION_TYPES ) );
    }

    public function testTheResolverKnowsEveryStorableType()
    {
        $resolver = dirname( __DIR__, 2 ) . '/explayouts/classes/explayoutsresolver.php';
        if ( !is_file( $resolver ) )
            $this->markTestSkipped( 'explayouts is not installed next to explayouts_ui' );
        require_once $resolver;
        if ( !defined( 'expLayoutsResolver::TARGET_TYPES' ) )
        {
            // an explayouts without the type lists: every storable type must at least be handled by the resolver
            $source = file_get_contents( $resolver );
            foreach ( array_merge( expLayoutsUiRuleInput::STORABLE_TARGET_TYPES, expLayoutsUiRuleInput::STORABLE_CONDITION_TYPES ) as $type )
                $this->assertStringContainsString( "'" . $type . "'", $source, $type );
            return;
        }
        // the storable types are the resolver's, and the fallback lists name the same
        $this->assertSame( expLayoutsResolver::TARGET_TYPES, expLayoutsUiRuleInput::storableTargetTypes() );
        $this->assertSame( expLayoutsResolver::CONDITION_TYPES, expLayoutsUiRuleInput::storableConditionTypes() );
        $this->assertEqualsCanonicalizing( expLayoutsResolver::TARGET_TYPES, expLayoutsUiRuleInput::STORABLE_TARGET_TYPES );
        $this->assertEqualsCanonicalizing( expLayoutsResolver::CONDITION_TYPES, expLayoutsUiRuleInput::STORABLE_CONDITION_TYPES );
    }

    public function testAModuleTargetOfAnAdminLayoutRuleIsKept()
    {
        $rejected = array();
        $targets = expLayoutsUiRuleInput::targets( array( 'module_view', 'module' ), array( 'content/view', 'user' ), $rejected );
        $this->assertSame( array( array( 'type' => 'module_view', 'value' => 'content/view' ), array( 'type' => 'module', 'value' => 'user' ) ), $targets );
        $this->assertSame( array(), $rejected );
    }
}
