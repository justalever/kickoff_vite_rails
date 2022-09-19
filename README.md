# Rails Kickoff Vite – WindiCSS

A rapid Rails 7.0+ application template. This particular template utilizes [WindiCSS](https://windicss.org/), a utility-first CSS framework for rapid UI development and [Vite](https://vitejs.dev/guide/), a build tool that aims to provide a faster and leaner development experience for modern web projects.

Inspired heavily by [Jumpstart](https://github.com/excid3/jumpstart) from [Chris Oliver](https://twitter.com/excid3/) and my previous [Kickoff Tailwind](https://github.com/justalever/kickoff_tailwind) Rails application that utilized Webpack/Tailwind CSS.

Be sure to also check out [Jumpstart Pro](https://jumpstartrails.com) to save loads of time creating your next Rails application. Chris, Jason, and I teamed up on it.

New to Rails? Check out my course called **[Hello Rails](https://hellorails.io)** or my **[YouTube channel](https://youtube.com/c/webcrunch)** for a bunch of free tutorials.

### Included gems

- [devise](https://github.com/plataformatec/devise)
- [friendly_id](https://github.com/norman/friendly_id)
- [sidekiq](https://github.com/mperham/sidekiq)
- [name_of_person](https://github.com/basecamp/name_of_person)
- [vite_rails](https://vite-ruby.netlify.app/guide/)

### WindiCSS by default

With Rails 6 we have webpacker by default now but it can become extremely slow to recompile as your application grows. Vite is an answer to this issue.

Vite consists of two major parts:

- A dev server that provides rich feature enhancements over native ES modules, for example extremely fast Hot Module Replacement (HMR).

- A build command that bundles your code with Rollup, pre-configured to output highly optimized static assets for production.

## How it works

When creating a new rails app simply pass the template file through.

### Creating a new app

Because Rails 6.1 ships with webpacker by default we need to skip installing it all together when creating a new app. The main flags you need are `--skip-webpack-install` and `--skip-javascript`.

**Important** - using these flags means **zero** javascript gets added to the app so you'll need to add libraries as you go. This template adds the following packages as a starting point:

- `trix`
- `@rails/actiontext`
- `@rails/ujs`
- `@rails/activestorage`
- `stimulus `
- `stimulus-vite-helpers`
- `typescript`
- `vite-plugin-stimulus-hmr`
- `vite-plugin-full-reload`
- `vite-plugin-windicss windicss`

⬇️ Clone the repo

```bash
git clone git@github.com:justalever/kickoff_vite_rails.git
```

🏈 Kickoff a new app

```bash
rails new sample_app --skip-webpack-install --skip-javascript -m kickoff_vite_rails/template.rb
```

### Once installed what do I get?

- Vite + WindiCSS configured in the `app/frontend` directory.
- Devise with a new `name` field already migrated in. The name field maps to the `first_name` and `last_name` fields in the database thanks to the `name_of_person` gem.
- Enhanced views using WindiCSS.
- Support for Friendly IDs thanks to the handy [friendly_id](https://github.com/norman/friendly_id) gem. Note that you'll still need to do some work inside your models for this to work. This template installs the gem and runs the associated generator.
- Git initialization out of the box.
- Custom defaults for button and form elements.

### Boot it up

`$ rails server`

### Boot up the dev server

`$ bin/vite dev`

### Watch an overview

 📹 [https://web-crunch.com/posts/vite-ruby-on-rails-application-template](https://web-crunch.com/posts/vite-ruby-on-rails-application-template)

### Extending Vite

Check out the [Vite Ruby website](https://vite-ruby.netlify.app/) for ideas on how to integrate more frameworks and toolings into your application.
