
<!--- Get default margins for entity. --->
<cfset entityMargins = getBaseTagData( "cf_email" ).providers[ "margins.h3" ] />

<!--- Define custom tag attributes. --->
<cfparam name="attributes.class" type="string" default="" />
<cfparam name="attributes.margins" type="string" default="#entityMargins#" />
<cfparam name="attributes.style" type="string" default="" />

<!--- // ------------------------------------------------------------------------- // --->
<!--- // ------------------------------------------------------------------------- // --->

<cfswitch expression="#thistag.executionMode#">
	<cfcase value="end">
		<cfoutput>

			<cfmodule
				template="../Styles.cfm"
				variable="inlineStyle"
				entityName="h3"
				entityClass="#attributes.class#"
				entityStyle="#attributes.style#">
			</cfmodule>

			<cfmodule template="../BlockMargins.cfm" margins="#attributes.margins#">

				<h3
					class="#trim( 'html-entity-h3 #attributes.class#' )#"
					style="#inlineStyle#">
					#thistag.generatedContent#
				</h3>

			</cfmodule>

			<!--- Reset the generated content since we're overriding the output. --->
			<cfset thistag.generatedContent = "" />

		</cfoutput>
	</cfcase>
</cfswitch>