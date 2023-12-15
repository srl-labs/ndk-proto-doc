<script lang="ts">
	import '../../../app.css';

	/** @type {import('./$types').PageData} */
	export let data;

	import yaml from 'js-yaml';

	import type { Interfaces } from '$lib/interfaces';
	import ndkLoad from '$lib/ndk.yaml?raw';

	import Navigation from '$lib/components/Navigation.svelte';
	import TableLoader from '$lib/components/TableLoader.svelte';

	const interfaces = yaml.load(ndkLoad) as Interfaces;

	const p = data.interface;
	const s = data.service;
	const v = data.version;

	const vd = interfaces[p].services[s].versions[v];

	const pd = data.protoDoc;
	const files = pd.files;
</script>

<svelte:head>
	<title>{interfaces[p].name} - {interfaces[p].services[s].name} {v}</title>
</svelte:head>

<div class="dark:bg-gray-800 pb-2">
	<div class="lg:flex">
		<Navigation {interfaces} iKey={p} sKey={s} version={v} {files} srcDoc={vd} />
		<TableLoader {files} scalarValueTypes={pd.scalarValueTypes} />
	</div>
</div>
