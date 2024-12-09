#!/usr/bin/env bash

export CandidateName="Charles N Wyble"
export CandidatePhone="**1 818 280 7059**"
export CandidateLocation="Austin TX / Raleigh NC / Remote"
export CandidateEmail="**reachableceo@reachableceo.com**"
export CandidateOneLineSummary="Senior (**Staff level**) **System Engineer/SRE/Architect** with extensive Linux/Windows/Networking/Cyber security background and experience."
export CandidateLinkedin="https://www.linkedin.com/in/charles-wyble-412007337/"
export CandidateGithub="https://www.github.com/reachableceo"
export CandidateLogo="D:/tsys/@ReachableCEO/ReachableCEO.png"
export CandidateTagline="Tenacity. Velocity. Focus."
export ResumeSourceCode="https://git.knownelement.com/reachableceo/MarkdownResume-Pipeline"
export URLCOLOR="blue"
export PAGEBACKGROUND="../vendor/git.knownelement.com/ExternalVendorCode/pandoc-latex-template/examples/page-background/backgrounds/background5.pdf"

####################################################
#DO NOT CHANGE ANYTHING BELOW THIS LINE
####################################################

# shellcheck disable=SC1091
#source "$(dirname "${BASH_SOURCE[0]}")/bash3boilerplate.sh"

############################################################
# Setup globals
############################################################

readonly MO_PATH="bash ../vendor/git.knownelement.com/ExternalVendorCode/mo/mo"
readonly BUILD_OUTPUT_DIR="D:\tsys\@ReachableCEO\resume.reachableceo.com"
readonly BUILD_TEMP_DIR="../build-temp"
readonly BUILDYAML_JOBBOARD="$BUILD_TEMP_DIR/JobBoard.yml"
readonly BUILDYAML_CLIENTSUBMISSION="$BUILD_TEMP_DIR/ClientSubmission.yml"

echo "Cleaning up from previous runs..."

JobBoardMarkdownOutputFile="$BUILD_TEMP_DIR/job-board/Resume.md"
JobBoardPDFOutputFile="$BUILD_OUTPUT_DIR/job-board/CharlesNWyble-Resume.pdf"
JobBoardMSWordOutputFile="$BUILD_OUTPUT_DIR/job-board/CharlesNWyble-Resume.doc"

ClientSubmissionMarkdownOutputFile="$BUILD_TEMP_DIR/client-submission/Resume.md"
ClientSubmissionPDFOutputFile="$BUILD_OUTPUT_DIR/client-submission//Resume.pdf"
ClientSubmissionMSWordOutputFile="$BUILD_OUTPUT_DIR/client-submission/Resume.doc"

rm $BUILDYAML_JOBBOARD
rm $JobBoardMarkdownOutputFile
rm $JobBoardPDFOutputFile
rm $JobBoardMSWordOutputFile

rm $BUILDYAML_CLIENTSUBMISSION
rm $ClientSubmissionMarkdownOutputFile
rm $ClientSubmissionPDFOutputFile
rm $ClientSubmissionMSWordOutputFile

# Expand variables into rendered YAML files. These will be used by pandoc to create the output artifacts

$MO_PATH ./BuildTemplate-JobBoard.yml > $BUILDYAML_JOBBOARD
$MO_PATH ./BuildTemplate-ClientSubmission.yml > $BUILDYAML_CLIENTSUBMISSION

echo "Combining markdown files into single input file for pandoc..."

# Create contact info md file
$MO_PATH ../Templates/ContactInfo/ContactInfo-JobBoard.md > $BUILD_TEMP_DIR/ContactInfo-JobBoard.md
$MO_PATH ../Templates/ContactInfo/ContactInfo-ClientSubmit.md > $BUILD_TEMP_DIR/ContactInfo-ClientSubmit.md

#Pull in contact info
cat $BUILD_TEMP_DIR/ContactInfo-JobBoard.md >> $JobBoardMarkdownOutputFile
echo " " >> $JobBoardMarkdownOutputFile

cat $BUILD_TEMP_DIR/ContactInfo-ClientSubmit.md >> $ClientSubmissionMarkdownOutputFile
echo " " >> $ClientSubmissionMarkdownOutputFile

echo "## Highlights from my 22 year career" >> $JobBoardMarkdownOutputFile
echo "## Highlights from my 22 year career" >> $ClientSubmissionMarkdownOutputFile

cat ../Templates/SkillsAndProjects/Projects.md >> $JobBoardMarkdownOutputFile
echo "\pagebreak" >> $JobBoardMarkdownOutputFile

cat ../Templates/SkillsAndProjects/Projects.md >> $ClientSubmissionMarkdownOutputFile
echo "\pagebreak" >> $ClientSubmissionMarkdownOutputFile

echo " " >> $JobBoardMarkdownOutputFile
echo "## Employment History" >> $JobBoardMarkdownOutputFile
echo " " >> $JobBoardMarkdownOutputFile

echo " " >> $ClientSubmissionMarkdownOutputFile
echo "## Employment History" >> $ClientSubmissionMarkdownOutputFile
echo " " >> $ClientSubmissionMarkdownOutputFile

#And here we do some magic...
#Pull in :

# employer
# title
# start/end dates of employment 
# long form position summary data from each position

IFS=$'\n\t'
for position in \
$(cat ../Templates/WorkHistory/WorkHistory.csv); do

COMPANY="$(echo $position|awk -F ',' '{print $1}')"
TITLE="$(echo $position|awk -F ',' '{print $2}')"
DATEOFEMPLOY="$(echo $position|awk -F ',' '{print $3}')"

echo " " >> "$JobBoardMarkdownOutputFile"
echo "**$COMPANY | $TITLE | $DATEOFEMPLOY**" >> $JobBoardMarkdownOutputFile
echo " " >> "$JobBoardMarkdownOutputFile"

echo "**$COMPANY | $TITLE | $DATEOFEMPLOY**" >> $ClientSubmissionMarkdownOutputFile
echo " " >> "$ClientSubmissionMarkdownOutputFile"

echo " " >> "$JobBoardMarkdownOutputFile"
cat ../Templates/JobHistoryDetails/$COMPANY.md >> "$JobBoardMarkdownOutputFile"
echo " " >> "$JobBoardMarkdownOutputFile"

cat ../Templates/JobHistoryDetails/$COMPANY.md >> "$ClientSubmissionMarkdownOutputFile"
echo " " >> "$ClientSubmissionMarkdownOutputFile"
done

#Pull in my skills and generate a beautiful table.

echo "\pagebreak" >> $JobBoardMarkdownOutputFile
echo " " >> "$JobBoardMarkdownOutputFile"
echo "## Skills" >> "$JobBoardMarkdownOutputFile"
echo " " >> "$JobBoardMarkdownOutputFile"

echo "\pagebreak" >> $ClientSubmissionMarkdownOutputFile
echo " " >> "$ClientSubmissionMarkdownOutputFile"
echo "## Skills" >> "$ClientSubmissionMarkdownOutputFile"
echo " " >> "$ClientSubmissionMarkdownOutputFile"

#Table heading
echo "|Skill|Experience|Skill Details|" >> $JobBoardMarkdownOutputFile
echo "|---|---|---|" >> $JobBoardMarkdownOutputFile

echo "|Skill|Experience|Skill Details|" >> $ClientSubmissionMarkdownOutputFile
echo "|---|---|---|" >> $ClientSubmissionMarkdownOutputFile

#Table rows
IFS=$'\n\t'
for skill in \
$(cat ../Templates/SkillsAndProjects/Skills.csv); do
SKILL_NAME="$(echo $skill|awk -F '|' '{print $1}')"
SKILL_YEARS="$(echo $skill|awk -F '|' '{print $2}')"
SKILL_DETAIL="$(echo $skill|awk -F '|' '{print $3}')"
echo "|**$SKILL_NAME**|$SKILL_YEARS|$SKILL_DETAIL|" >> $JobBoardMarkdownOutputFile
echo "|**$SKILL_NAME**|$SKILL_YEARS|$SKILL_DETAIL|" >> $ClientSubmissionMarkdownOutputFile

done
unset IFS

echo "Generating PDF output for job board version..."

pandoc \
"$JobBoardMarkdownOutputFile" \
--template eisvogel \
--metadata-file="../build-temp/JobBoard.yml" \
--from markdown \
--to=pdf \
--output $JobBoardPDFOutputFile

echo "Generating MSWord output for job board version..."

pandoc \
"$JobBoardMarkdownOutputFile" \
--metadata-file="../build-temp/JobBoard.yml" \
--from markdown \
--to=docx \
--reference-doc=resume-docx-reference.docx \
--output $JobBoardMSWordOutputFile

echo "Generating PDF output for client submission version..."

pandoc \
"$ClientSubmissionMarkdownOutputFile" \
--template eisvogel \
--metadata-file="../build-temp/ClientSubmission.yml" \
--from markdown \
--to=pdf \
--output $ClientSubmissionPDFOutputFile

echo "Generating MSWord output for client submission version..."

pandoc \
"$ClientSubmissionMarkdownOutputFile" \
--metadata-file="../build-temp/ClientSubmission.yml" \
--from markdown \
--to=docx \
--reference-doc=resume-docx-reference.docx \
--output $ClientSubmissionMSWordOutputFile