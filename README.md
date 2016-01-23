# Meetings
Meetings allows team members to view upcoming meetings and set helpful reminders right from any slack channel. Meetings runs Rails 5.0.0 Beta on Ruby 2.3.

## Usage
```
/mymeetings [today, tomorrow or week]
Example: /mymeetings today
```

## Development
```
git clone repo-url
cd /directory
bundle
./start (from terminal). If you get permission error, just do chmod 777 start
```

## System dependencies

Meetings requires the following softwares:

* Ruby (2.3)
* PostgreSQL (9.4.5)

The versions listed are tested and confirmed to work, but the software may also be
compatible with earlier versions.

### Running
```bash
	$ bundle exec rails db:create db:migrate
	$ bundle exec rails console
	$ ./start from terminal
```
