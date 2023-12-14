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
		<div class="md:grid md:grid-cols-2 md:gap-20 md:items-center">
			<div>
				<p class="mb-4"><img src="/images/nokia_w.svg" width="100" alt="Logo" /></p>
				<h3 class="text-3xl text-yellow-200 font-light mt-6">SR Linux Protobuf Documentation</h3>
				<p class="mt-4 text-white text-m max-w-[450px]">User interface for SR Linux services 
					<sup>
						<a class="text-white-400 hover:text-blue-300" href="https://learn.srlinux.dev/blog/2023/gnxi-browser-a-documentation-ui-for-openconfig-grpc-services/">
							<svg class="w-4 h-4 inline-flex" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 20">
								<path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7.529 7.988a2.502 2.502 0 0 1 5 .191A2.441 2.441 0 0 1 10 10.582V12m-.01 3.008H10M19 10a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/>
							</svg>
						</a>
					</sup>
				</p>
			</div>
			<div class="mt-5 bg-white rounded-lg shadow-xl">
				<div class="my-1.5 h-[305px] overflow-y-auto scroll-light">
					<ul>
						{#each panelList as item, i}
							<li class="items-center p-4 text-gray-900 hover:bg-gray-100 {i > 0 ? 'border-t' : ''}">
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
	</div>
	<div class="flex-grow-0 flex-shrink-0">
		<Footer home={true} />
	</div>
</div>
