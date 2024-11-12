# Peer-Review for Programming Exercise 2

## Description

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.

## Due Date and Submission Information

See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.

# Solution Assessment

## Peer-reviewer Information

- _name:_ Noel Lee
- _email:_ noelee@ucdavis.edu

### Description

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect

    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great

    Minor flaws in one or two objectives.

#### Good

    Major flaw and some minor flaws.

#### Satisfactory

    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory

    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.

---

## Solution Assessment

### Stage 1

- [ ] Perfect
- [ ] Great
- [ ] Good
- [X] Satisfactory
- [ ] Unsatisfactory

---

#### Justification

The position lock works fine but even the zoom function crashes the entire program.

---

### Stage 2

- [ ] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [X] Unsatisfactory

---

#### Justification
Program is not functional and it is unclear how to test any of the other cameras as the cameraselector is not cycling through them.


---

### Stage 3

- [ ] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [X] Unsatisfactory

---

#### Justification

Program is not functional and it is unclear how to test any of the other cameras as the cameraselector is not cycling through them.

---

### Stage 4

- [ ] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [X] Unsatisfactory

---

#### Justification

Program is not functional and it is unclear how to test any of the other cameras as the cameraselector is not cycling through them.

---

### Stage 5

- [ ] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [X] Unsatisfactory

---

#### Justification

Program is not functional and it is unclear how to test any of the other cameras as the cameraselector is not cycling through them.

---

# Code Style

### Description

Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

- [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.

#### Style Guide Infractions
- [Inconsistency in formatting](https://github.com/ensemble-ai/exercise-2-camera-control-elmerleon/blob/d56b85619c49574b5b4b4784f088ad0860ca6bb0/Obscura/scripts/camera_controllers/auto_scroll.gd#L87). While the naming here is good, the same things were implemented with much better visual formatting in another file. There is inconsistency here and it would have been better for this to also be formatted like the push_box one.
- [Comment typos and vagueness](https://github.com/ensemble-ai/exercise-2-camera-control-elmerleon/blob/d56b85619c49574b5b4b4784f088ad0860ca6bb0/Obscura/scripts/camera_controllers/position_lock_lerp_target_foucs.gd#L44). The comments don't make much sense to a new reader and there are numerous typos throughout many comments in the files.

#### Style Guide Exemplars
- [Good comments and formatting](https://github.com/ensemble-ai/exercise-2-camera-control-elmerleon/blob/d56b85619c49574b5b4b4784f088ad0860ca6bb0/Obscura/scripts/camera_controllers/push_box.gd#L25). THe very clear indentation and comments help greatly in showing exactly what the code blocks are for while being concise.

---

# Best Practices

### Description

If the student has followed best practices then feel free to point at these code segments as examplars.

If the student has breached the best practices and has done something that should be noted, please add the infraction.

This should be similar to the Code Style justification.

#### Best Practices Infractions

- [Redundant code](https://github.com/ensemble-ai/exercise-2-camera-control-elmerleon/blob/d56b85619c49574b5b4b4784f088ad0860ca6bb0/Obscura/scripts/camera_controllers/auto_scroll.gd#L23) Setting global_position to target.global_position seems to be unnecessary as the camera should just lock to the vessel position.

#### Best Practices Exemplars
- [Good use of variable names](https://github.com/ensemble-ai/exercise-2-camera-control-elmerleon/blob/d56b85619c49574b5b4b4784f088ad0860ca6bb0/Obscura/scripts/camera_controllers/auto_scroll.gd#L87). The named variables of left right top bottom improves readability and are good future proofing for modifications.
- [Good function seperation](https://github.com/ensemble-ai/exercise-2-camera-control-elmerleon/blob/d56b85619c49574b5b4b4784f088ad0860ca6bb0/Obscura/scripts/camera_controllers/position_lock_lerp_target_foucs.gd#L70). The draw_logic function is implemented well and in a compartimentalized way that leaves the main code more organized.