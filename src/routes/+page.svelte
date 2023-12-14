<script lang="ts">
	import '../app.css';

	import yaml from 'js-yaml';
	import { onMount } from 'svelte';
	import { page } from '$app/stores';

	import Footer from '$lib/components/Footer.svelte';

	import type { Interfaces } from '$lib/interfaces';
	import ifcLoad from '$lib/interfaces.yaml?raw';

	const interfaces = yaml.load(ifcLoad) as Interfaces;
	const key = "srlinux";

	let panelList: any[] = [];
	Object.keys(interfaces[key].services).forEach((el) => {
		panelList.push({
			name: interfaces[key].services[el].name,
			desc: interfaces[key].services[el].description,
			href: `${key}/${el}`
		});
	});
</script>

<svelte:head>
	<title>SR Linux Protobuf Documentation</title>
</svelte:head>

<div class="flex flex-col items-center min-h-screen pt-5 has-header-img font-nunito">
	<div class="flex-grow-1 flex-shrink-0 m-auto px-10">
		<div class="py-5">
			<p class="mb-4"><img src="/images/nokia_w.svg" width="100" alt="Logo" /></p>
			<h3 class="text-3xl text-yellow-200 font-light mt-6">SR Linux Protobuf Documentation</h3>
			<div class="mt-5 rounded h-[305px] overflow-y-auto">
				<ul>
					{#each panelList as item}
						<li class="items-center my-2 p-3 rounded-lg text-gray-900 bg-gray-300 hover:bg-gray-100 border border-gray-300">
							<a data-sveltekit-reload href={item.href}>
								<p class="">{item.name}</p>
								{#if item.desc}
									<p class="mt-1 font-light text-sm">{item.desc}</p>
								{/if}
							</a>
						</li>
					{/each}
				</ul>
			</div>
		</div>
	</div>
	<div class="flex-grow-0 flex-shrink-0">
		<Footer home={true} />
	</div>
</div>
