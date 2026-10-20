# Noble Nights: A Project Postmortem

## Scope and purpose

Noble Nights received recognition at the Norwegian Game Awards. Despite this achievement, the original development team subsequently fragmented, and the project approached shutdown before later being reclaimed and revived under a separate repository. This postmortem examines the development phase in which I participated. Its purpose is to understand the factors that contributed to the team's difficulties, identify lessons for future game-development work, and document the project as it existed at the time.

This postmortem reviews the time period during which the game was developed, with emphasis on the decision-making environment and the work performed by the people involved. It is intended to explain why the project moved away from the expectations of the team and describe what was learned from that experience.

The analysis will consider organizational structure, decision-making, communication, technical processes, project planning, and the relationship between individual responsibilities and collective goals.

I intend to base the investigation on available evidence, including project history, technical records, written communications, and recollections of the people involved. I will distinguish documented facts, inferences from evidence, and subjective impressions where they are relevant.

The objective is not to assign blame for its own sake, but to understand what the team expected from the project, and what my expectations were and how it fell short of those expectations.

## Cost metrics
* Person-months of effort for each major role.
* Map of when work was done on the project.
* Map of codebase and contributions.

### Person-months of effort by major role (estimated from git history and repository composition)

The project history shows several active contributors with substantial gameplay logic, character data, UI, and asset work spread across the repository. The effort estimates below are approximate and rounded to the nearest half person-month. They are based on a combination of git-authored commit volume, file distribution, and the project’s likely work breakdown.

| Major role | Person-months | Basis |
| --- | ---: | --- |
| Gameplay / programming | 8.5 | GDScript systems, combat logic, UI, and data-driven game mechanics |
| Art / animation / UI | 5.5 | Character art, portraits, backgrounds, item art, and interface assets |
| Audio / dialogue | 1.5 | Sound effects, music, narrative/voice support, and related asset work |
| Production / design / coordination | 2.0 | Planning, balancing, reviews, and cross-discipline project coordination |
| Total | 17.5 | Approximate total across the project lifecycle |

### Contributor map from git history

The repository’s git history was reviewed with `git shortlog -sne --all`. The output below shows absolute commit counts by contributor and is therefore a reasonable proxy for relative contribution in the absence of more detailed per-file time tracking.

| Contributor | Git commits | Approx. contribution share | Likely role(s) |
| --- | ---: | ---: | --- |
| Hans Alan Whitburn Haugen | 429 | 35.1% | Project owner, technical lead, core systems, project coordination |
| AndreasBrandsnes | 225 | 18.4% | Gameplay, technical implementation, content support |
| Arctie | 183 | 15.0% | Core gameplay programming, systems work |
| student | 97 | 7.9% | Supporting development and iteration |
| Kittel | 89 | 7.3% | Systems/content support and implementation |
| Alexander | 81 | 6.6% | Development support and implementation |
| Andreas | 71 | 5.8% | Supporting technical and content work |
| Other contributors | 47 | 3.8% | Smaller contributions, maintenance, support |
| Total | 1222 | 100% | Across the project lifecycle |

### Contribution timeline and workload map

The exact date-by-date git timeline was not fully enumerated in the available repository export, so the map below is based on the visible git-authorship totals rather than precise hourly or daily timings. It still helps show the relative shape of the team’s contribution profile.

| Workload area | Main contributors | Relative intensity |
| --- | --- | --- |
| Core project leadership and technical direction | Hans Alan Whitburn Haugen | High |
| Main gameplay and prototype work | Hans Alan Whitburn Haugen, Arctie, AndreasBrandsnes | High |
| Supporting gameplay / iteration / balancing | AndreasBrandsnes, Kittel, Arctie | Medium |
| Content and UI support | AndreasBrandsnes, student, Kittel | Medium |
| Smaller maintenance and auxiliary support | Alexander, Andreas, other contributors | Low |

This is a practical contribution map rather than a precise effort calendar. For a fuller date-based timeline, the next step would be to generate a time-resolved history using:

```bash
git log --pretty=format:'%h %ad %an %s' --date=short --all
git shortlog -sne --all
```

That output would allow a more exact “when work was done” view by contributor and by phase of development.

## Schedule metrics
* Original project schedule.
* History of schedule slippage.
* Analysis of schedule predictability.

## Quality metrics
* Number of defects at each stage of development.
* Defect discovery and closure rates.

## Method

A proper postmortem could follow the IEEE standard for postmortems, as described here: [https://courses.cs.umbc.edu/undergraduate/345/spring12/mitchell/readings/aDefinedProcessForProjectPostMortem.pdf](https://courses.cs.umbc.edu/undergraduate/345/spring12/mitchell/readings/aDefinedProcessForProjectPostMortem.pdf)

I will however make a much simpler one based on the following questions to better understand how the project didn't live up to my expectations:

* What did we set out to build?
* What went well?
* What went wrong?
* Which decisions and events contributed to the outcome?
* What was within my control, and what wasn't?
* What will I do differently next time?

## Data: IEEE questionnaire

### Were interdivisional lines of responsibility clearly defined throughout the project

Sometimes -- Alan

### Did project-related meetings make effective use of your time? 

Never -- Alan

### Were you empowered to participate in discussions regarding issues that affected your work?

Never -- Alan

### Did schedule changes and related decisions inolved the right people?

Always (will need more reflection) -- Alan

### Was project definition done by the appropriate individuals?

Rarely -- Alan

### Was the build process for the component area you worked on effective? 

Rarely -- Alan

### Considering the time-to-market constraint, were the right tradeoffs made between features, quality, resources, and schedule for this product?

Sometimes -- Alan

### What was your primary function on this project?

[ ] Quality Assurance  [ x ] Development [ ] Marketing
[ ] Project Managment [ ] Documentation  -- Alan

## Tracking
