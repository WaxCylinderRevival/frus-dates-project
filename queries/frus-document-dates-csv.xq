xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";

(:
import module namespace dates="http://xqdev.com/dateparser" at "xmldb:exist://db/apps/twitter/modules/date-parser.xqm";
:)

import module namespace functx="http://www.functx.com" at "http://www.xqueryfunctions.com/xq/functx-1.0-nodoc-2007-01.xq";

declare option output:method "csv";
declare option output:csv "header=yes";

(: Not Complete :)

let $coll := collection('frus-volumes')
let $vols := doc($coll/frus1969-76v03.xml)
let $documents := $coll//tei:div[attribute::type='document']
for $doc in $documents
let $docID := data($doc/attribute::xml:id)

let $dateline := $doc//tei:dateline
let $dateMR := data($doc//tei:dateline/tei:date/attribute::when)
let $dateNL := data($doc//tei:dateline/tei:date/text())
let $dateMRTest :=
let $dmrTest := $dateMR
return
if (empty($dateMR))
then "not applicable"
else
if ($dateMR castable as xs:dateTime)
then "valid dateTime"
else
if ($dateMR castable as xs:date)
then "valid date"
else "invalid"

let $certainty := 
let $dateCertaintyTest := $dateMR
return
if (empty($dateCertaintyTest))
then "estimated"
else "certain"
let $precision := "To determine"

let $head := $doc/tei:head[not(note)]
let $docType := 
let $docTypeTest := string($head)
return
if (matches($docTypeTest,'(Editorial Note|Editor’s Note)'))
then "editorial note"
else "historical document"
let $dateType := 
let $dateTypeTest := string($head)
return
if (matches($dateTypeTest,'(Editorial Note|Editor’s Note)'))
then "coverage"
else "creation"
let $sourceNote := $doc//tei:note[attribute::type='source'][1]
let $source := substring-after(substring-before($sourceNote,'.'),'Source: ')
let $sourceToken := tokenize($source,',')
let $repositoryPrimary := normalize-space($sourceToken[1])
let $repositoryUnit := normalize-space($sourceToken[2])

let $volID := substring-before(document-uri($doc), '.xml')

(:
let $volCoverage := doc(concat('/db/apps/frus/bibliography/', $volID, '.xml'))/volume/coverage
:)

return 
<record>
    <documentID>{$docID}</documentID>
    <dateSingle-machineReadable>{$dateMR}</dateSingle-machineReadable>
    <dateSingle-machineReadableTest>{$dateMRTest}</dateSingle-machineReadableTest>
    <dateSingle-naturalLanguage>{$dateNL}</dateSingle-naturalLanguage>
    <fromDate-machineReadable></fromDate-machineReadable>
    <toDate-machineReadbale></toDate-machineReadbale>
    <notBefore-machineReadable></notBefore-machineReadable>
    <notAfter-machineReadable></notAfter-machineReadable>
    <dateRange-naturalLanguage></dateRange-naturalLanguage>
    <calendar>Gregorian</calendar>
    <era>CE</era>
    <certainty>{$certainty}</certainty>
    <precision>{$precision}</precision>
    <documentType>{$docType}</documentType>
    <dateType>{$dateType}</dateType>
    <documentTitle></documentTitle>
    <documentDateline>{data($dateline)}</documentDateline>
    <documentSource>{data($source)}</documentSource>
    <repository>{data($repositoryPrimary)}</repository>
    <repositoryUnit>{data($repositoryUnit)}</repositoryUnit>
    <documentSourceNote>{data($sourceNote)}</documentSourceNote>
    (:
    <volumeStartDate>{data($volCoverage[1])}</volumeStartDate> :)
    (:
    <volumeEndDate>{data($volCoverage[2])}</volumeEndDate>
    :)
</record>