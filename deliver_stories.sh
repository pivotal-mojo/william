#!/usr/bin/env bash
curl -H "X-TrackerToken: $TRACKER_TOKEN" -X PUT http://www.pivotaltracker.com/services/v3/projects/1529909/stories/deliver_all_finished -d ""